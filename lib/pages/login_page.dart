import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  final Language lang;
  const LoginPage({Key? key, required this.lang}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final s = localizedStrings[widget.lang]!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: s['email']!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: s['password']!,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Supabase.instance.client.auth.signInWithPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    } on AuthException catch (e) {
                      final key = e.message.toLowerCase().contains('not confirmed')
                          ? 'email_not_confirmed'
                          : 'invalid_credentials';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(s[key]!)),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    }
                  },
                  child: Text(s['login']!),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(s['signup']!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
