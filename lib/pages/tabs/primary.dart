import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PrimaryTab extends StatelessWidget {
  const PrimaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.down,
        icon: Icons.bug_report_outlined,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.play_arrow_outlined),
            label: 'Ball Selector',
            shape: CircleBorder(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.play_arrow_outlined),
            label: 'Anagram Sorter',
            shape: CircleBorder(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.play_arrow_outlined),
            label: 'Box Selector',
            shape: CircleBorder(),
          )
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Spacer(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        child: const Text('Iniciar'),
                        onPressed: () {
                          
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}