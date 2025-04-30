import 'dart:math';
import 'package:flutter/material.dart';
import 'panda_party_logic.dart';

class PandaPartyScreen extends StatefulWidget {
  const PandaPartyScreen({super.key});

  @override
  State<PandaPartyScreen> createState() => _PandaPartyScreenState();
}

class _PandaPartyScreenState extends State<PandaPartyScreen> {
  final int pandaCount = 5;
  final int correctPandaCount = 2;
  final double pandaSize = 60;
  Size screenSize = Size.zero;
  final List<PandaData> pandas = [];
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        screenSize = MediaQuery.of(context).size;
      });
    });
  }

  void startGame() {
    _generatePandas();
    setState(() {
      gameStarted = true;
    });
  }

  void _generatePandas() {
    final random = Random();
    final Set<int> correctIndexes = {};

    while (correctIndexes.length < correctPandaCount) {
      correctIndexes.add(random.nextInt(pandaCount));
    }

    pandas.clear();
    for (int i = 0; i < pandaCount; i++) {
      pandas.add(PandaData(
        isCorrect: correctIndexes.contains(i),
      ));
    }
  }

  void restartPandas() {
    for (var panda in pandas) {
      final state = panda.key.currentState;
      if (state != null && state.isStopped) {
        state.restartMovement();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (screenSize == Size.zero) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/panda_party/background_3.png', fit: BoxFit.cover),
          ),
          if (!gameStarted)
            Center(
              child: GestureDetector(
                onTap: startGame,
                child: Image.asset(
                  'assets/panda_party/IconParkTwotonePlay.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
          if (gameStarted)
            ...pandas.asMap().entries.map((entry) {
              final index = entry.key;
              final panda = entry.value;

              return PandaWidget(
                key: panda.key,
                screenSize: screenSize,
                size: pandaSize,
                isCorrect: panda.isCorrect,
                onCorrectTap: () {
                  setState(() {
                    pandas.removeAt(index);
                  });
                  restartPandas();
                },
                onWrongTap: () {
                  restartPandas();
                },
                getOtherPandas: () {
                  return pandas
                      .where((p) => p.key != panda.key)
                      .map((p) => p.key)
                      .toList();
                },
                topMargin: 220,
                bottomMargin: 30,
              );
            }),
        ],
      ),
    );
  }
}

class PandaData {
  final bool isCorrect;
  final GlobalKey<PandaWidgetState> key = GlobalKey();

  PandaData({required this.isCorrect});
}
