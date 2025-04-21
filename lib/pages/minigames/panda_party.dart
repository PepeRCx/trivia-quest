import 'package:flutter/material.dart';

class PandaPartyPage extends StatefulWidget {
  const PandaPartyPage({super.key});

  @override
  State<PandaPartyPage> createState() => _PandaPartyPageState();
}

class _PandaPartyPageState extends State<PandaPartyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text('Play'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}