import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class CategoriesPage extends StatefulWidget {
  final Language lang;
  const CategoriesPage({Key? key, required this.lang}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await Supabase.instance.client
          .from('categories')
          .select()
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);
      setState(() {
        _categories = List<Map<String, dynamic>>.from(data as List);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _showCategoryDialog({Map<String, dynamic>? category}) async {
    final nameController = TextEditingController(text: category?['name'] ?? '');
    final isEditing = category != null;
    await showDialog<bool>(
      context: context,
      builder: (_) {
        final s = localizedStrings[widget.lang]!;
        return AlertDialog(
          title: Text(isEditing ? s['edit_category']! : s['new_category']!),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: s['name']!),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(s['cancel']!)),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text;
                try {
                  if (isEditing) {
                    await Supabase.instance.client
                        .from('categories')
                        .update({'name': name})
                        .eq('id_category', category!['id_category']);
                  } else {
                    await Supabase.instance.client
                        .from('categories')
                        .insert({'name': name});
                  }
                  Navigator.pop(context);
                  _loadCategories();
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

  Future<void> _deleteCategory(Map<String, dynamic> category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        final s = localizedStrings[widget.lang]!;
        return AlertDialog(
          title: Text(s['delete_category']!),
          content: Text('${s['delete']} "${category['name']}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s['cancel']!)),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text(s['delete']!)),
          ],
        );
      },
    );
    if (confirm == true) {
      try {
        await Supabase.instance.client
            .from('categories')
            .update({'deleted_at': DateTime.now().toIso8601String()})
            .eq('id_category', category['id_category']);
        _loadCategories();
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
      appBar: AppBar(title: Text(s['expense_category']!)),
      body: ListView.separated(
        itemCount: _categories.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (_, i) {
          final category = _categories[i];
          return ListTile(
            title: Text(category['name']),
            subtitle: Text('Created: ${category['created_at']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showCategoryDialog(category: category),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteCategory(category),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
