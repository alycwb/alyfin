import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/categories_page.dart';
import 'pages/types_page.dart';
import 'pages/expenses_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/landing_page.dart'; // Add this line
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
    'email_not_confirmed': 'Email not confirmed',
    'no_expenses': 'No expenses found',
    'add_expense': 'Add Expense',
    // Landing page translations
    'landing_header': 'Take total control of your personal finances',
    'start_now': 'Start now',
    'landing_announcement': '🚀 Alysoft Finances is 100% free. No ads, no tricks. Accessible financial management for everyone!',
    'how_it_works_title': 'How it works',
    'benefit1_title': 'Create your account',
    'benefit1_desc': 'Quick and free sign-up to start in a few clicks.',
    'benefit2_title': 'Add your expenses',
    'benefit2_desc': 'Register expenses and goals easily, all in one place.',
    'benefit3_title': 'Track everything',
    'benefit3_desc': 'View results with clear charts and reports.',
    'why_use_title': 'Why use Alysoft Finances?',
    'free_title': 'Free',
    'free_desc': 'No fees, subscriptions, or surprises. It’s totally free.',
    'easy_title': 'Easy to use',
    'easy_desc': 'Clean, intuitive design so you can focus on what matters.',
    'no_ads_title': 'No ads',
    'no_ads_desc': 'Zero distractions: focus on your financial organization.',
    'control_title': 'More control',
    'control_desc': 'Manage your finances with more clarity and confidence.',
    'footer_text': '© 2025 Alysoft Finances. All rights reserved.',
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
    'email_not_confirmed': 'Email não confirmado',
    'no_expenses': 'Nenhuma despesa encontrada',
    'add_expense': 'Adicionar Despesa',
    // Landing page traduções
    'landing_header': 'Controle total das suas finanças pessoais',
    'start_now': 'Comece agora',
    'landing_announcement': '🚀 Alysoft Finances é 100% gratuito. Sem anúncios, sem pegadinhas. A gestão financeira acessível chegou para todos!',
    'how_it_works_title': 'Como funciona',
    'benefit1_title': 'Crie sua conta',
    'benefit1_desc': 'Cadastro rápido e gratuito para começar em poucos cliques.',
    'benefit2_title': 'Adicione seus gastos',
    'benefit2_desc': 'Registre despesas e metas com facilidade, tudo em um só lugar.',
    'benefit3_title': 'Acompanhe tudo',
    'benefit3_desc': 'Veja seus resultados com gráficos e relatórios fáceis de entender.',
    'why_use_title': 'Por que usar o Alysoft Finances?',
    'free_title': 'Gratuito',
    'free_desc': 'Sem taxas, assinaturas ou surpresas. É totalmente grátis.',
    'easy_title': 'Fácil de usar',
    'easy_desc': 'Design limpo e intuitivo para você focar no que importa.',
    'no_ads_title': 'Sem anúncios',
    'no_ads_desc': 'Zero distrações: seu foco é sua organização financeira.',
    'control_title': 'Mais controle',
    'control_desc': 'Acompanhe suas finanças com mais clareza e confiança.',
    'footer_text': '© 2025 Alysoft Finances. Todos os direitos reservados.',
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
  bool _showLanding = true; // Add this line
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
      scrollBehavior: NoGlowScrollBehavior(),
      scaffoldMessengerKey: _scaffoldMessengerKey,
      navigatorObservers: [routeObserver],
      theme: ThemeData(primarySwatch: Colors.grey),
      debugShowCheckedModeBanner: false,
      title: 'Alysoft Finances',
      home: Scaffold(
        extendBodyBehindAppBar: _showLanding,
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
        backgroundColor: _showLanding ? Colors.transparent : Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: _showLanding ? Colors.transparent : Colors.white,
          elevation: _showLanding ? 0 : 4,
          automaticallyImplyLeading: !_showLanding,
          leading: _showLanding
              ? IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )
              : null,
          centerTitle: true,
          title: _showLanding ? const SizedBox.shrink() : const Text('Alysoft Finances'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<Language>(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                value: _lang,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: Language.en, child: Text('🇺🇸')),
                  DropdownMenuItem(value: Language.pt, child: Text('🇧🇷')),
                ],
                onChanged: (lang) {
                  if (lang != null) setState(() => _lang = lang);
                },
              ),
            ),
          ],
        ),
        body: _showLanding
            ? LandingPage(strings: localizedStrings[_lang]!, onStart: () => setState(() => _showLanding = false))
            : _loggedIn
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
                                } on AuthException catch (e) {
                                  final msg = e.message.toLowerCase();
                                  final key = msg.contains('not confirmed')
                                      ? 'email_not_confirmed'
                                      : 'invalid_credentials';
                                  _scaffoldMessengerKey.currentState?.showSnackBar(
                                    SnackBar(content: Text(strings[key]!)),
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
