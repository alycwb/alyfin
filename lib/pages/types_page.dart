import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class TypesPage extends StatefulWidget {
  final Language lang;
  const TypesPage({Key? key, required this.lang}) : super(key: key);

  @override
  _TypesPageState createState() => _TypesPageState();
}

class _TypesPageState extends State<TypesPage> {
  List<Map<String, dynamic>> _types = [];

  @override
  void initState() {
    super.initState();
    _loadTypes();
  }

  Future<void> _loadTypes() async {
    try {
      final data = await Supabase.instance.client
          .from('types')
          .select()
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);
      setState(() {
        _types = List<Map<String, dynamic>>.from(data as List);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _showTypeDialog({Map<String, dynamic>? type}) async {
    final nameController =
        TextEditingController(text: type != null ? type['name'] as String : '');
    final isEditing = type != null;
    await showDialog<bool>(
      context: context,
      builder: (_) {
        final s = localizedStrings[widget.lang]!;
        return AlertDialog(
          title: Text(isEditing ? s['edit_type']! : s['new_type']!),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: s['name']!),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(s['cancel']!)),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text;
                try {
                  if (isEditing) {
                    await Supabase.instance.client
                        .from('types')
                        .update({'name': name})
                        .eq('id_type', type!['id_type']);
                  } else {
                    await Supabase.instance.client
                        .from('types')
                        .insert({'name': name});
                  }
                  Navigator.pop(context);
                  _loadTypes();
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
    );
  }

  Future<void> _deleteType(Map<String, dynamic> type) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        final s = localizedStrings[widget.lang]!;
        return AlertDialog(
          title: Text(s['delete_type']!),
          content: Text('${s['delete']} "${type['name']}"?'),
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
            .from('types')
            .update({'deleted_at': DateTime.now().toIso8601String()})
            .eq('id_type', type['id_type']);
        _loadTypes();
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
      appBar: AppBar(title: Text(s['expense_type']!)),
      body: ListView.separated(
        itemCount: _types.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, i) {
          final type = _types[i];
          return ListTile(
            title: Text(type['name'] ?? ''),
            subtitle: Text('Created: ${type['created_at']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showTypeDialog(type: type),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteType(type),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTypeDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
