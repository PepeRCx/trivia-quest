
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class PandaWidget extends StatefulWidget {
  final Size screenSize;
  final double size;
  final bool isCorrect;
  final VoidCallback onCorrectTap;
  final VoidCallback onWrongTap;
  final List<GlobalKey<PandaWidgetState>> Function() getOtherPandas;
  final double topMargin;
  final double bottomMargin;

  const PandaWidget({
    super.key,
    required this.screenSize,
    required this.size,
    required this.isCorrect,
    required this.onCorrectTap,
    required this.onWrongTap,
    required this.getOtherPandas,
    required this.topMargin,
    required this.bottomMargin,
  });

  @override
  State<PandaWidget> createState() => PandaWidgetState();
}

class PandaWidgetState extends State<PandaWidget> {
  Offset position = Offset.zero;
  Offset direction = Offset.zero;
  bool isStopped = true;
  bool _isVisible = true;
  bool clickable = false;
  bool tapped = false;
  String imagePath = '';
  Timer? moveTimer;
  Timer? clickTimer;
  Timer? markTimer;
  final random = Random();

  bool get isVisible => _isVisible;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    moveTimer?.cancel();
    clickTimer?.cancel();
    markTimer?.cancel();
    super.dispose();
  }

  void _initialize() {
    imagePath = widget.isCorrect ? 'assets/panda_party/mask_1.png' : 'assets/panda_party/mask_2.png';
    _setInitialPosition();
    direction = _randomDirection();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          imagePath = 'assets/panda_party/mask_2.png';
          isStopped = false;
        });
        _startMoving();
        clickTimer = Timer(const Duration(seconds: 10), () {
          if (mounted) {
            setState(() {
              isStopped = true;
              clickable = true;
            });
          }
        });
      }
    });
  }

  void _setInitialPosition() {
    const maxAttempts = 100;
    int attempts = 0;
    while (attempts < maxAttempts) {
      final newPos = Offset(
        random.nextDouble() * (widget.screenSize.width - widget.size),
        widget.topMargin +
            random.nextDouble() *
                (widget.screenSize.height - widget.topMargin - widget.bottomMargin - widget.size),
      );
      bool overlap = widget.getOtherPandas().any((otherKey) {
        final other = otherKey.currentState;
        if (other == null) return false;
        return (other.position - newPos).distance < widget.size;
      });
      if (!overlap) {
        position = newPos;
        return;
      }
      attempts++;
    }
    position = Offset(
      random.nextDouble() * (widget.screenSize.width - widget.size),
      widget.topMargin +
          random.nextDouble() *
              (widget.screenSize.height - widget.topMargin - widget.bottomMargin - widget.size),
    );
  }

  Offset _randomDirection() {
    final angle = random.nextDouble() * 2 * pi;
    return Offset(cos(angle), sin(angle));
  }

  void _startMoving() {
    moveTimer?.cancel();
    moveTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || isStopped) return;

      Offset nextPos = position + direction * 2;

      if (nextPos.dx < 0 || nextPos.dx > widget.screenSize.width - widget.size) {
        direction = Offset(-direction.dx, direction.dy);
      }
      if (nextPos.dy < widget.topMargin || nextPos.dy > widget.screenSize.height - widget.bottomMargin - widget.size) {
        direction = Offset(direction.dx, -direction.dy);
      }

      for (final otherKey in widget.getOtherPandas()) {
        final other = otherKey.currentState;
        if (other == null || !other.isVisible) continue;
        if ((other.position - position).distance < widget.size) {
          direction = -direction;
          break;
        }
      }

      setState(() {
        position = Offset(
          (position.dx + direction.dx * 2).clamp(0, widget.screenSize.width - widget.size),
          (position.dy + direction.dy * 2).clamp(widget.topMargin, widget.screenSize.height - widget.bottomMargin - widget.size),
        );
      });
    });
  }

  void _onTap() {
    if (!clickable || tapped) return;
    tapped = true;

    setState(() {
      imagePath = widget.isCorrect
          ? 'assets/panda_party/IconParkTwotoneCorrect.png'
          : 'assets/panda_party/IconParkTwotoneError.png';
    });

    markTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (widget.isCorrect) {
        _startMoving();
        widget.onCorrectTap();
      } else {
        widget.onWrongTap(); // Esto reinicia TODOS los pandas desde PandaGameScreen
      }
    });
  }

  void restartMovement() {
    if (!mounted || !isStopped) return;
    moveTimer?.cancel();
    clickTimer?.cancel();
    setState(() {
      imagePath = 'assets/panda_party/mask_2.png';
      isStopped = false;
      clickable = false;
      tapped = false;
    });
    _startMoving();
    clickTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          isStopped = true;
          clickable = true;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: _onTap,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
