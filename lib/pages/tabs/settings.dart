import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trivia_quest/services/auth.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {

  void _logout() async {
    try {
      await authService.value.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purpleAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(authService.value.currentUser?.displayName ?? 'Trivia User'),
                Text(authService.value.currentUser?.email ?? 'no email available'),
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Sincronizar evento'),
                leading: Icon(Icons.sync, color: Colors.purpleAccent),
              ),
              ListTile(
                title: const Text('Borrar cuenta'),
                leading: Icon(Icons.delete, color: Colors.purple),
                onTap: () => Navigator.pushNamed(context, '/delete_account'),
              ),
              ListTile(
                title: const Text('Cerrar sesión'),
                leading: Icon(Icons.logout, color: Colors.purpleAccent),
                onTap: () => _logout(),
              ),
            ],
          )
        ],
      )
    );
  }
}