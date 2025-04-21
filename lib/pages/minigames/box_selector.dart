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
                  Text('Box selector')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}