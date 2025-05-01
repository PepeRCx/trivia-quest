import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  late final AudioPlayer player;

  final int rowCount = 20;
  final int columnCount = 20;
  final int winningScore = 10;

  final int wallsPerFruit = 3;

  late Timer gameLoop;
  List<Point<int>> snake = [
      const Point(5, 5),
      const Point(4, 5)
    ];
  Point<int> food = const Point(5, 5);
  List<Point<int>> walls = [];
  Point<int> direction = const Point(0, -1); // Starts moving up
  bool isGameOver = false;
  bool isGameWon = false;
  Timer? stopWatchTimer;
  int elapsedMilliseconds = 0;

  String get formattedTime {
    final seconds = (elapsedMilliseconds ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = ((elapsedMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$seconds.$milliseconds';
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    startGame();
  }

  void startGame() {
    snake = [
      const Point(5, 5),
      const Point(4, 5),
      const Point(3, 5),
    ];
    walls = [];
    food = generateFood();
    direction = const Point(0, 1);
    isGameOver = false;
    isGameWon = false;

    startStopWatch();

    gameLoop = Timer.periodic(const Duration(milliseconds: 150), (_) {
      setState(() {
        moveSnake();
      });
    });
  }

  Point<int> generateFood() {
    final rand = Random();
    Point<int> newFood;
    do {
      newFood = Point(
        rand.nextInt(columnCount),
        rand.nextInt(rowCount),
      );
    } while (snake.contains(newFood));

    generateWalls(newFood);

    return newFood;
  }

  void generateWalls(Point<int> foodPosition) {
    final rand = Random();
    walls.clear();

    final List<Point<int>> possiblePositions = [
      const Point(0, 1),  // Below
      const Point(0, -1), // Above
      const Point(1, 0),  // Right
      const Point(-1, 0), // Left
      const Point(1, 1),  // Bottom-right
      const Point(-1, 1), // Bottom-left
      const Point(1, -1), // Top-right
      const Point(-1, -1), // Top-left
      const Point(2, 0),  // 2 Right
      const Point(-2, 0), // 2 Left
      const Point(0, 2),  // 2 Below
      const Point(0, -2), // 2 Above
    ];

    possiblePositions.shuffle();

    int wallsAdded = 0;
    for (var offset in possiblePositions) {
      if (wallsAdded >= wallsPerFruit) break;

      final wallPosition = Point(
        foodPosition.x + offset.x,
        foodPosition.y + offset.y,
      );

      if (wallPosition.x >= 0 &&
        wallPosition.x < columnCount &&
        wallPosition.y >= 0 &&
        wallPosition.y < rowCount &&
        !snake.contains(wallPosition) &&
        wallPosition != foodPosition) {
          walls.add(wallPosition);
          wallsAdded++;
        }
    }
  }

  Future<void> moveSnake() async {
    final newHead = snake.first + direction;

    if (checkCollision(newHead)) {
      gameLoop.cancel();
      isGameOver = true;
      stopStopWach();
      return;
    }

    snake.insert(0, newHead);

    if (newHead == food) {
      print('hello');
      try {
        await player.play(AssetSource('snake/eat.wav'));
      } catch (e) {
        print('Audio error: $e');
      }
      food = generateFood();
      if (snake.length - 3 >= winningScore) {
        gameLoop.cancel();
        isGameWon = true;
        stopStopWach();
      }
    } else {
      snake.removeLast();
    }
  }

  bool checkCollision(Point<int> point) {
    return point.x < 0 ||
        point.y < 0 ||
        point.x >= columnCount ||
        point.y >= rowCount ||
        snake.contains(point) ||
        walls.contains(point);
  }

  void changeDirection(Point<int> newDir) {
    if (direction + newDir != const Point(0, 0)) {
      direction = newDir;
    }
  }

  void startStopWatch() {
    stopWatchTimer?.cancel();
    elapsedMilliseconds = 0;

    stopWatchTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        elapsedMilliseconds += 10;
      });
    });

  }

  void stopStopWach() {
    stopWatchTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cellSize = screenSize.width / columnCount;

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.expand(
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 15),
                Text(
                  "Objetivo: ${snake.length -3}/$winningScore",
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                Spacer(),
                Text('Tiempo: $formattedTime',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                SizedBox(width: 15),
              ],
            ),
            SizedBox(height: 50),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: (details) {
                final dx = details.delta.dx;
                final dy = details.delta.dy;
            
                // Check which is the dominant direction
                if (dx.abs() > dy.abs()) {
                  // Horizontal swipe
                  if (dx > 0) {
                    changeDirection(const Point(1, 0)); // Right
                  } else {
                    changeDirection(const Point(-1, 0)); // Left
                  }
                } else {
                  // Vertical swipe
                  if (dy > 0) {
                    changeDirection(const Point(0, 1)); // Down
                  } else {
                    changeDirection(const Point(0, -1)); // Up
                  }
                }
              },
              child: Center(
                child: Container(
                  width: cellSize * columnCount,
                  height: cellSize * rowCount,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Stack(
                    children: [
                      //Render the walls
                      for (var wall in walls)
                        Positioned(
                          left: wall.x * cellSize,
                          top: wall.y * cellSize,
                          child: Container(
                            width: cellSize,
                            height: cellSize,
                            decoration: BoxDecoration(
                              color: Colors.brown[800],
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      //Render the snake
                      for (var p in snake)
                        Positioned(
                          left: p.x * cellSize,
                          top: p.y * cellSize,
                          child: Container(
                            width: cellSize,
                            height: cellSize,
                            decoration: BoxDecoration(
                              color: p == snake.first ? Colors.green : const Color.fromARGB(255, 245, 255, 233),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      Positioned(
                        left: food.x * cellSize,
                        top: food.y * cellSize,
                        child: Container(
                          width: cellSize,
                          height: cellSize,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                      if (isGameOver || isGameWon)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 45, 44, 44),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isGameWon ? "Ganaste" : "Game Over",
                                  style: const TextStyle(color: Colors.white, fontSize: 32),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() => startGame());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white
                                  ),
                                  child: const Text("Reiniciar", style: TextStyle(color: Colors.black),),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
