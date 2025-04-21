
import 'dart:math';
import 'package:flutter/material.dart';

class BallSorterPage extends StatefulWidget {
  const BallSorterPage({super.key});

  @override
  BallSorterPageState createState() => BallSorterPageState();
}

class BallSorterPageState extends State<BallSorterPage> with SingleTickerProviderStateMixin {

  static const ballBlack1 = 'lib/assets/ball_sorter/BallBlack_1.png';
  static const ballBlack2 = 'lib/assets/ball_sorter/BallBlack_2.png';

  static const ballWhite1 = 'lib/assets/ball_sorter/BallWhite_1.png';
  static const ballWhite2 = 'lib/assets/ball_sorter/BallWhite_2.png';

  static const balls = [
    ballBlack1,
    ballBlack2,
    ballWhite1,
    ballWhite2,
  ];

  String currentBall = balls[Random().nextInt(balls.length)];

  void changeBall() {
    setState(() {
      String newBall;
      do {
        newBall= balls[Random().nextInt(balls.length)];
      } while(newBall == currentBall);
      currentBall = newBall;
    });
  }

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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      final inAnimation = Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero
                      ).animate(animation);

                      final outAnimation = Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-1, 0),
                      ).animate(animation);

                      return SlideTransition(
                        position: animation.status == AnimationStatus.reverse
                          ? outAnimation
                          : inAnimation,
                        child: child,
                      );
                    },
                    child: Image.asset(
                      currentBall,
                      key: ValueKey(currentBall),
                      width: 250,
                      height: 250,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            backgroundColor: const Color.fromARGB(255, 46, 46, 46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                          child: const Text('Blanco', style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            changeBall();
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
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                          child: const Text('Negro', style: TextStyle(color: Colors.black),),
                          onPressed: () {
                            changeBall();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}