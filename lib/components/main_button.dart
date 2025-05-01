import 'package:flutter/material.dart';


class main_button extends StatelessWidget {
  const main_button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 28, 251, 255)
          ),
          onPressed: () {
            
          },
          child: const Text('Jugar', style: TextStyle(fontSize: 18, color: Colors.black)),
        ),
      ),
    );
  }
}