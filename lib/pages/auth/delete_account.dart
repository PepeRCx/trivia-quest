import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trivia_quest/services/auth.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  DeleteAccountPageState createState() => DeleteAccountPageState();
}

class DeleteAccountPageState extends State<DeleteAccountPage> {

  String errorMessage = '';
  bool isPasswordVisible = false;
  bool isPasswordConfirmVisible = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  void deleteAccount() async {
    if (passwordController.text != passwordConfirmController.text) {
      setState(() {
        errorMessage = 'Las contraseñas no coinciden';
      });
      return;
    }
    try {
      await authService.value.deleteAccount(email: authService.value.currentUser!.email!, password: passwordController.text);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Algo salió mal';
      });
    }
  }

  Future<bool?> showConfirmationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estás seguro?'),
        content: const Text('Esta acción'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar cuenta'),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrar cuenta'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      }),
                    )
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordConfirmController,
                  obscureText: !isPasswordConfirmVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordConfirmVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() {
                        isPasswordConfirmVisible = !isPasswordConfirmVisible;
                      }),
                    )
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: const Text('Borrar cuenta'),
                    onPressed: () {
                      showConfirmationDialog(context).then((value) {
                        if (value == true) {
                          deleteAccount();
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}