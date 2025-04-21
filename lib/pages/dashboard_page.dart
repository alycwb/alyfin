import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'expenses_page.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final Language lang;
  const DashboardPage({Key? key, required this.lang}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAware {
  double _totalThisMonth = 0.0;
  List<Map<String, dynamic>> _recentExpenses = [];
  List<Map<String, dynamic>> _topTypes = [];
  String _topCategoryName = '';
  double _topCategoryAmount = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id ?? '';
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    try {
      // Soma de despesas do mês atual
      final data = await Supabase.instance.client
          .from('expenses')
          .select('amount, expense_date')
          .isFilter('deleted_at', null)
          .eq('id_user', userId)
          .gte('expense_date', firstDay.toIso8601String())
          .order('expense_date', ascending: false) as List;
      double sum = 0;
      for (var item in data) {
        sum += (item['amount'] as num).toDouble();
      }
      // Últimos 5 lançamentos
      final recentData = await Supabase.instance.client
          .from('expenses')
          .select('description, amount, expense_date, categories(name), types(name)')
          .isFilter('deleted_at', null)
          .eq('id_user', userId)
          .order('expense_date', ascending: false)
          .limit(5) as List;
      // Top types e categoria
      final monthDetails = await Supabase.instance.client
          .from('expenses')
          .select('amount, categories(name), types(name)')
          .isFilter('deleted_at', null)
          .eq('id_user', userId)
          .gte('expense_date', firstDay.toIso8601String())
          .order('expense_date', ascending: false) as List;
      final typeSums = <String, double>{};
      final categorySums = <String, double>{};
      for (var item in monthDetails) {
        final amt = (item['amount'] as num).toDouble();
        final typeName = item['types']['name'] as String;
        final catName = item['categories']['name'] as String;
        typeSums[typeName] = (typeSums[typeName] ?? 0) + amt;
        categorySums[catName] = (categorySums[catName] ?? 0) + amt;
      }
      final sortedTypes = typeSums.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      final topTypesList = sortedTypes.take(2).map((e) => {'name': e.key, 'amount': e.value}).toList();
      final sortedCats = categorySums.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      final topCatEntry = sortedCats.isNotEmpty ? sortedCats.first : MapEntry('', 0.0);
      setState(() {
        _totalThisMonth = sum;
        _recentExpenses = List<Map<String, dynamic>>.from(recentData);
        _topTypes = topTypesList;
        _topCategoryName = topCatEntry.key;
        _topCategoryAmount = topCatEntry.value;
        _loading = false;
      });
    } catch (error) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    final s = localizedStrings[widget.lang]!;
    final fmt = NumberFormat.decimalPattern(widget.lang == Language.pt ? 'pt_BR' : 'en_US');

    if (_recentExpenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(s['no_expenses']!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExpensesPage(lang: widget.lang)),
              ),
              child: Text(s['add_expense']!),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dashboard summary cards
          Row(
            children: [
              if (_topTypes.isNotEmpty)
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(_topTypes[0]['name']),
                          const SizedBox(height: 4),
                          Text(
                            fmt.format((_topTypes[0]['amount'] as num).toDouble()),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_topTypes.length > 1)
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(_topTypes[1]['name']),
                          const SizedBox(height: 4),
                          Text(
                            fmt.format((_topTypes[1]['amount'] as num).toDouble()),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(_topCategoryName),
                        const SizedBox(height: 4),
                        Text(
                          fmt.format(_topCategoryAmount),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('${s['expenses']} - ${s['this_month']!}'),
                        const SizedBox(height: 4),
                        Text(
                          fmt.format(_totalThisMonth),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Recent section
          Text(
            s['recent']!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Material(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentExpenses.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final e = _recentExpenses[i];
                return ListTile(
                  title: Text(e['description'] ?? ''),
                  subtitle: Text('${e['categories']['name']} / ${e['types']['name']}'),
                  trailing: Text(fmt.format((e['amount'] as num).toDouble())),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
