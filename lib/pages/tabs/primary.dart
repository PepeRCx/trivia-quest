import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:trivia_quest/components/main_button.dart';

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
            label: 'Ball Sorter',
            shape: CircleBorder(),
            onTap: () => Navigator.pushNamed(context, '/ball_sorter'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.play_arrow_outlined),
            label: 'Ball Sorter 2',
            shape: CircleBorder(),
            onTap: () =>  Navigator.pushNamed(context, '/ball_sorter_2'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.play_arrow_outlined),
            label: 'Anagram Sorter',
            shape: CircleBorder(),
            onTap: () => Navigator.pushNamed(context, '/anagram_sorter'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.bluetooth),
            label: 'Bluetooth Test',
            shape: CircleBorder(),
            onTap: () => Navigator.pushNamed(context, '/bluetooth'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.pets),
            label: 'Panda Party',
            shape: CircleBorder(),
            onTap: () => Navigator.pushNamed(context, '/panda_party'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.line_style),
            label: 'Classi Snake',
            shape: CircleBorder(),
            onTap: () => Navigator.pushNamed(context, '/classic_snake'),
          ),
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
                    MainButton(
                      text: 'Jugar',
                      onPressed: () {
                        
                      },
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