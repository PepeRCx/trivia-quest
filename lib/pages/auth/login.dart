import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trivia_quest/pages/home.dart';
import 'package:trivia_quest/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  bool isPasswordVisible = false;
  var errorMessage = '';

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Por favor, llene todos los campos';
      });
      showScaffold();
      return;
    }
    try {
      await authService.value.signIn(email: emailController.text, password: passwordController.text);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Error desconocido';
      });
      showScaffold();
    }
  }

  void showScaffold() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          width: double.infinity,
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
        ),
        duration: const Duration(seconds: 3),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage();
            };
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: const Text('Bienvenido'),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: CupertinoButton.filled(
                            child: const Text('Iniciar Sesión'),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Nuevo en Trivia?'),
                        SizedBox(
                          height: 50,
                          child: CupertinoButton(
                            child: const Text('Crear una cuenta'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}