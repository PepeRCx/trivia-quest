import 'package:flutter/material.dart';
import 'package:trivia_quest/components/main_button.dart';

class FavoriteTab extends StatelessWidget {
  const FavoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainButton(
                    text: 'Ball Sorter',
                    onPressed: () {
                      Navigator.pushNamed(context, '/ball_sorter');
                    },
                  ),
                  SizedBox(height: 20),
                  MainButton(
                    text: 'Ball Sorter 2',
                    onPressed: () {
                      Navigator.pushNamed(context, '/ball_sorter_2');
                    },
                  ),
                  SizedBox(height: 20),
                  MainButton(
                    text: 'Anagram Sorter',
                    onPressed: () {
                      Navigator.pushNamed(context, '/anagram_sorter');
                    },
                  ),
                  SizedBox(height: 20),
                  MainButton(
                    text: 'Panda Party',
                    onPressed: () {
                      Navigator.pushNamed(context, '/panda_party');
                    },
                  ),
                  SizedBox(height: 20),
                  MainButton(
                    text: 'Classic Snake',
                    onPressed: () {
                      Navigator.pushNamed(context, '/classic_snake');
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}