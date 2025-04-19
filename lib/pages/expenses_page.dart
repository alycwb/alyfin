import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class ExpensesPage extends StatefulWidget {
  final Language lang;
  const ExpensesPage({Key? key, required this.lang}) : super(key: key);

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Map<String, dynamic>> _expenses = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _types = [];
  late String _userId;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    _userId = user?.id ?? '';
    _loadLookups().then((_) => _loadExpenses());
  }

  Future<void> _loadLookups() async {
    try {
      final categoriesData = await Supabase.instance.client
          .from('categories')
          .select('id_category,name')
          .isFilter('deleted_at', null);
      _categories = List<Map<String, dynamic>>.from(categoriesData as List);

      final typesData = await Supabase.instance.client
          .from('types')
          .select('id_type,name')
          .isFilter('deleted_at', null);
      _types = List<Map<String, dynamic>>.from(typesData as List);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _loadExpenses() async {
    try {
      final expensesData = await Supabase.instance.client
          .from('expenses')
          .select('*, categories(name), types(name)')
          .isFilter('deleted_at', null)
          .eq('id_user', _userId)
          .order('created_at', ascending: false);
      setState(() {
        _expenses = List<Map<String, dynamic>>.from(expensesData as List);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _showExpenseDialog({Map<String, dynamic>? expense}) async {
    final isEditing = expense != null;
    final descController = TextEditingController(
        text: expense != null ? expense['description'] ?? '' : '');
    final amtController = TextEditingController(
        text: expense != null ? expense['amount'].toString() : '');
    DateTime expenseDate = isEditing
        ? DateTime.parse(expense!['expense_date'])
        : DateTime.now();
    DateTime effectiveDate = isEditing
        ? DateTime.parse(expense['effective_date'])
        : DateTime.now();
    String? selectedCategory =
        isEditing ? expense['id_category'] as String? : null;
    String? selectedType = isEditing ? expense['id_type'] as String? : null;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          final s = localizedStrings[widget.lang]!;
          return AlertDialog(
            title:
                Text(isEditing ? s['edit_expense']! : s['new_expense']!),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(labelText: s['description']!),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amtController,
                    decoration: InputDecoration(labelText: s['amount']!),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: _categories
                        .map<DropdownMenuItem<String>>((c) {
                      final id = c['id_category'] as String;
                      final name = c['name'] as String;
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => selectedCategory = v),
                    decoration: InputDecoration(labelText: s['category']!),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: _types
                        .map<DropdownMenuItem<String>>((t) {
                      final id = t['id_type'] as String;
                      final name = t['name'] as String;
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => selectedType = v),
                    decoration: InputDecoration(labelText: s['type']!),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: Text('${s['expense_date']!}: ${expenseDate.toLocal().toIso8601String().split('T')[0]}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final dt = await showDatePicker(
                        context: context,
                        initialDate: expenseDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (dt != null) {
                        setState(() => expenseDate = dt);
                      }
                    },
                  ),
                  ListTile(
                    title: Text('${s['effective_date']!}: ${effectiveDate.toLocal().toIso8601String().split('T')[0]}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final dt = await showDatePicker(
                        context: context,
                        initialDate: effectiveDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (dt != null) {
                        setState(() => effectiveDate = dt);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(s['cancel']!)),
              ElevatedButton(
                onPressed: () async {
                  final data = {
                    'description': descController.text,
                    'amount': double.tryParse(amtController.text) ?? 0.0,
                    'expense_date':
                        expenseDate.toIso8601String(),
                    'effective_date':
                        effectiveDate.toIso8601String(),
                    'id_category': selectedCategory,
                    'id_type': selectedType,
                    'id_user': _userId,
                  };
                  try {
                    if (isEditing) {
                      await Supabase.instance.client
                          .from('expenses')
                          .update(data)
                          .eq('id_expense', expense!['id_expense']);
                    } else {
                      await Supabase.instance.client
                          .from('expenses')
                          .insert(data);
                    }
                    Navigator.pop(context);
                    _loadExpenses();
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString())),
                    );
                  }
                },
                child: Text(isEditing ? s['save']! : s['add']!),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteExpense(
      Map<String, dynamic> expense) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        final s = localizedStrings[widget.lang]!;
        return AlertDialog(
          title: Text(s['delete_expense']!),
          content: Text(
              'Delete "${expense['description']}"?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(s['cancel']!)),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(s['delete']!)),
          ],
        );
      },
    );
    if (confirm == true) {
      try {
        await Supabase.instance.client
            .from('expenses')
            .update({'deleted_at': DateTime.now().toIso8601String()})
            .eq('id_expense', expense['id_expense']);
        _loadExpenses();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = localizedStrings[widget.lang]!;
    return Scaffold(
      appBar: AppBar(title: Text(s['expenses']!)),
      body: ListView.separated(
        itemCount: _expenses.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, i) {
          final ex = _expenses[i];
          return ListTile(
            title: Text(ex['description'] ?? ''),
            subtitle: Text(
                '${ex['amount']} - ${ex['categories']['name']} / ${ex['types']['name']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showExpenseDialog(expense: ex),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteExpense(ex),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
