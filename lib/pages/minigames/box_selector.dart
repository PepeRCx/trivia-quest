import 'package:flutter/material.dart';

class BoxSelectorPage extends StatefulWidget {
  const BoxSelectorPage({super.key});

  @override
  State<BoxSelectorPage> createState() => _BoxSelectorPageState();
}

class _BoxSelectorPageState extends State<BoxSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Intentos: 3/3'),
                      Spacer(),
                      Text('20:00'),
                      Spacer(),
                      Text('Puntaje: 0/20')
                    ],
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: 220,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white
                    ),
                    child: Center(
                      child: Text('Anagram', style: TextStyle(color: Colors.black, fontSize: 22),)
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 46, 46, 46),
                            padding: EdgeInsets.symmetric(vertical: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                          child: const Text('<-'),
                          onPressed: () {
                            
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                          ),
                          child: const Text('->', style: TextStyle(color: Colors.black),),
                          onPressed: () {
                            
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}