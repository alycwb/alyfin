import 'package:flutter/material.dart';

void main() {
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
    'signup': 'Sign Up',
    'username': 'User',
  },
  Language.pt: {
    'title': 'Entrar',
    'email': 'E-mail',
    'password': 'Senha',
    'forgot_password': 'Esqueceu a senha?',
    'login': 'Entrar',
    'signup': 'Cadastrar-se',
    'username': 'Usuário',
  },
};

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Language _lang = Language.en;

  @override
  Widget build(BuildContext context) {
    final strings = localizedStrings[_lang]!;
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.grey),
      debugShowCheckedModeBanner: false,
      title: 'Alysoft Finances',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Alysoft Finances'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: strings['email']),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: strings['password']),
                    obscureText: true,
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
                    onPressed: () {},
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
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        overlayColor: MaterialStateProperty.all(Colors.grey.shade200),
                      ),
                      onPressed: () {},
                      child: Text(strings['signup']!),
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
