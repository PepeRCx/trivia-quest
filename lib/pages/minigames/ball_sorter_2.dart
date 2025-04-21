
import 'dart:math';
import 'package:flutter/material.dart';

class BallSorter2ndPage extends StatefulWidget {
  const BallSorter2ndPage({super.key});

  @override
  BallSorter2ndPageState createState() => BallSorter2ndPageState();
}

class BallSorter2ndPageState extends State<BallSorter2ndPage> with SingleTickerProviderStateMixin {

  static const ballBlue1 = 'lib/assets/ball_sorter/ball_sorter_2/BallBlue_1.png';
  static const ballBlue2 = 'lib/assets/ball_sorter/ball_sorter_2/BallBlue_2.png';
  static const ballBlue3 = 'lib/assets/ball_sorter/ball_sorter_2/BallBlue_3.png';
  static const ballBlue4 = 'lib/assets/ball_sorter/ball_sorter_2/BallBlue_4.png';
  static const ballBlue5 = 'lib/assets/ball_sorter/ball_sorter_2/BallBlue_5.png';
  static const ballBlue6 = 'lib/assets/ball_sorter/ball_sorter_2/BallBlue_6.png';

  static const ballGreen1 = 'lib/assets/ball_sorter/ball_sorter_2/BallGreen_1.png';
  static const ballGreen2 = 'lib/assets/ball_sorter/ball_sorter_2/BallGreen_2.png';
  static const ballGreen3 = 'lib/assets/ball_sorter/ball_sorter_2/BallGreen_3.png';
  static const ballGreen4 = 'lib/assets/ball_sorter/ball_sorter_2/BallGreen_4.png';
  static const ballGreen5 = 'lib/assets/ball_sorter/ball_sorter_2/BallGreen_5.png';
  static const ballGreen6 = 'lib/assets/ball_sorter/ball_sorter_2/BallGreen_6.png';

  static const ballWhite1 = 'lib/assets/ball_sorter/ball_sorter_2/BallWhite_1.png';
  static const ballWhite2 = 'lib/assets/ball_sorter/ball_sorter_2/BallWhite_2.png';
  static const ballWhite3 = 'lib/assets/ball_sorter/ball_sorter_2/BallWhite_3.png';
  static const ballWhite4 = 'lib/assets/ball_sorter/ball_sorter_2/BallWhite_4.png';
  static const ballWhite5 = 'lib/assets/ball_sorter/ball_sorter_2/BallWhite_5.png';
  static const ballWhite6 = 'lib/assets/ball_sorter/ball_sorter_2/BallWhite_6.png';

  static const balls = [
    ballBlue1,
    ballBlue2,
    ballBlue3,
    ballBlue4,
    ballBlue5,
    ballBlue6,
    ballGreen1,
    ballGreen2,
    ballGreen3,
    ballGreen4,
    ballGreen5,
    ballGreen6,
    ballWhite1,
    ballWhite2,
    ballWhite3,
    ballWhite4,
    ballWhite5,
    ballWhite6,
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
                  ElevatedButton(
                    onPressed: () {
                      changeBall();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 76),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    child: const Text('Verde', style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            backgroundColor: const Color(0xFF1AFF25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                          child: const Text('Blanco', style: TextStyle(color: Colors.black),),
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
                          child: const Text('Azul', style: TextStyle(color: Colors.black),),
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