import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/categories_page.dart';
import 'pages/types_page.dart';
import 'pages/expenses_page.dart';
import 'pages/dashboard_page.dart';
// RouteObserver para atualização de telas
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wqbnjtyxhvucsbsflxcq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndxYm5qdHl4aHZ1Y3Nic2ZseGNxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwNzg0MTUsImV4cCI6MjA2MDY1NDQxNX0.xXb6u0pcXw1HOzvxD9R37hWqLzerUB57tbHsuMZqI4Q',
  );
  runApp(const MyApp());
}

enum Language { en, pt }

final localizedStrings = {
  Language.en: {
    'title': 'Login',
    'email': 'Email',
    'password': 'Password',
    'forgot_password': 'Forgot Password?',
    'login': 'Login',
    'pricing': 'Pricing',
    'features': 'Features',
    'enterprise': 'Enterprise',
    'signup': 'Sign Up',
    'username': 'User',
    'name': 'Name',
    'dashboard': 'Dashboard',
    'expenses': 'Expenses',
    'expense_type': 'Expense Type',
    'expense_category': 'Expense Category',
    'logout': 'Logout',
    'cancel': 'Cancel',
    'save': 'Save',
    'add': 'Add',
    'delete': 'Delete',
    'new_category': 'New Category',
    'edit_category': 'Edit Category',
    'delete_category': 'Delete Category',
    'new_type': 'New Type',
    'edit_type': 'Edit Type',
    'delete_type': 'Delete Type',
    'new_expense': 'New Expense',
    'edit_expense': 'Edit Expense',
    'delete_expense': 'Delete Expense',
    'description': 'Description',
    'amount': 'Amount',
    'category': 'Category',
    'type': 'Type',
    'expense_date': 'Expense Date',
    'effective_date': 'Effective Date',
    'this_month': 'This Month',
    'recent': 'Recent',
    'top_types': 'Top 2 Expense Types',
    'top_category': 'Top Category',
    'invalid_credentials': 'Invalid username or password',
    'invalid_amount': 'Invalid amount format',
  },
  Language.pt: {
    'title': 'Entrar',
    'email': 'E-mail',
    'password': 'Senha',
    'forgot_password': 'Esqueceu a senha?',
    'login': 'Entrar',
    'pricing': 'Preços',
    'features': 'Recursos',
    'enterprise': 'Empresarial',
    'signup': 'Cadastrar-se',
    'username': 'Usuário',
    'name': 'Nome',
    'dashboard': 'Dashboard',
    'expenses': 'Gastos',
    'expense_type': 'Tipo do Gasto',
    'expense_category': 'Categoria do Gasto',
    'logout': 'Sair',
    'cancel': 'Cancelar',
    'save': 'Salvar',
    'add': 'Adicionar',
    'delete': 'Excluir',
    'new_category': 'Nova Categoria',
    'edit_category': 'Editar Categoria',
    'delete_category': 'Excluir Categoria',
    'new_type': 'Novo Tipo',
    'edit_type': 'Editar Tipo',
    'delete_type': 'Excluir Tipo',
    'new_expense': 'Nova Despesa',
    'edit_expense': 'Editar Despesa',
    'delete_expense': 'Excluir Despesa',
    'description': 'Descrição',
    'amount': 'Valor',
    'category': 'Categoria',
    'type': 'Tipo',
    'expense_date': 'Data da Despesa',
    'effective_date': 'Data Efetiva',
    'this_month': 'Este Mês',
    'recent': 'Recentes',
    'top_types': 'Maiores Tipos de Gasto',
    'top_category': 'Maior Categoria',
    'invalid_credentials': 'Usuário ou senha inválidos',
    'invalid_amount': 'Formato de valor inválido',
  },
};

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Language _lang = Language.en;
  bool _loggedIn = false;
  bool _obscurePassword = true;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginEmailController.text = 'alysson.isidro@gmail.com';
    _loginPasswordController.text = 'Pass.135';
  }

  Future<void> _showSignUpDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        final s = localizedStrings[_lang]!;
        return AlertDialog(
          title: Text(s['signup']!),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: s['name']!)),
                const SizedBox(height: 8),
                TextField(controller: emailController, decoration: InputDecoration(labelText: s['email']!)),
                const SizedBox(height: 8),
                TextField(controller: passwordController, decoration: InputDecoration(labelText: s['password']!), obscureText: true),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.auth.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                    data: {'full_name': nameController.text},
                  );
                  Navigator.pop(context);
                  _scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Registration successful, check your email')),
                  );
                } catch (error) {
                  _scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                }
              },
              child: Text(s['signup']!),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = localizedStrings[_lang]!;
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      navigatorObservers: [routeObserver],
      theme: ThemeData(primarySwatch: Colors.grey),
      debugShowCheckedModeBanner: false,
      title: 'Alysoft Finances',
      home: Scaffold(
        drawer: Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          width: 150,
          child: Container(
            color: Colors.grey[900],
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final s = localizedStrings[_lang]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_loggedIn) ...[
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              overlayColor: Colors.grey.shade300,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardPage(lang: _lang)));
                            },
                            child: Text(s['dashboard']!),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              overlayColor: Colors.grey.shade300,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ExpensesPage(lang: _lang)));
                            },
                            child: Text(s['expenses']!),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              overlayColor: Colors.grey.shade300,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => TypesPage(lang: _lang)));
                            },
                            child: Text(s['expense_type']!),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              overlayColor: Colors.grey.shade300,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => CategoriesPage(lang: _lang)));
                            },
                            child: Text(s['expense_category']!),
                          ),
                          const Divider(color: Colors.grey),
                        ],
                        for (final key in _loggedIn
                            ? ['pricing', 'features', 'enterprise']
                            : ['login', 'pricing', 'features', 'enterprise'])
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              overlayColor: Colors.grey.shade300,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(s[key]!),
                          ),
                        if (_loggedIn) ...[
                          const Divider(color: Colors.grey),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              overlayColor: Colors.grey.shade300,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              await Supabase.instance.client.auth.signOut();
                              setState(() => _loggedIn = false);
                            },
                            child: Text(s['logout']!),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Alysoft Finances'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: DropdownButton<Language>(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  value: _lang,
                  style: const TextStyle(color: Colors.black),
                  selectedItemBuilder: (BuildContext context) {
                    return Language.values.map((lang) {
                      final flag = lang == Language.en ? '🇺🇸' : '🇧🇷';
                      final label = lang == Language.en ? 'English' : 'Português';
                      return Row(
                        children: [
                          Text(flag, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 4),
                          Text(label, style: const TextStyle(color: Colors.black)),
                        ],
                      );
                    }).toList();
                  },
                  underline: const SizedBox(),
                  dropdownColor: Colors.grey[200],
                  onChanged: (Language? newLang) {
                    if (newLang != null) setState(() => _lang = newLang);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Language.en,
                      child: Row(
                        children: [
                          Text('🇺🇸'),
                          SizedBox(width: 4),
                          Text('English'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Language.pt,
                      child: Row(
                        children: [
                          Text('🇧🇷'),
                          SizedBox(width: 4),
                          Text('Português'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _loggedIn
            ? DashboardPage(lang: _lang)
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _loginEmailController,
                          decoration: InputDecoration(labelText: strings['email']),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _loginPasswordController,
                          decoration: InputDecoration(
                            labelText: strings['password']!,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          obscureText: _obscurePassword,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                              overlayColor: MaterialStateProperty.all(Colors.grey.shade200),
                            ),
                            onPressed: () {},
                            child: Text(strings['forgot_password']!),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await Supabase.instance.client.auth.signInWithPassword(
                                email: _loginEmailController.text,
                                password: _loginPasswordController.text,
                              );
                              setState(() => _loggedIn = true);
                            } on AuthException catch (_) {
                              _scaffoldMessengerKey.currentState?.showSnackBar(
                                SnackBar(content: Text(strings['invalid_credentials']!)),
                              );
                            } catch (error) {
                              _scaffoldMessengerKey.currentState?.showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(strings['login']!),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Builder(
                            builder: (innerContext) {
                              return TextButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  overlayColor: MaterialStateProperty.all(Colors.grey.shade200),
                                ),
                                onPressed: () => _showSignUpDialog(innerContext),
                                child: Text(strings['signup']!),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
