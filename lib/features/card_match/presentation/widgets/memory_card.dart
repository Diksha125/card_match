import 'dart:math' as math;

import 'package:flutter/material.dart';

class MemoryCard extends StatefulWidget {
  final String value;
  final bool isFlipped;
  final bool isMatched;
  final VoidCallback? onTap;

  const MemoryCard({
    super.key,
    required this.value,
    required this.isFlipped,
    required this.isMatched,
    required this.onTap,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
      value: widget.isFlipped || widget.isMatched ? 1.0 : 0.0,
    );

    if (widget.isFlipped || widget.isMatched) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldVisible =
        oldWidget.isFlipped || oldWidget.isMatched;

    final newVisible =
        widget.isFlipped || widget.isMatched;

    if (newVisible && !oldVisible) {
      _controller.forward();
    } else if (!newVisible && oldVisible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isMatched ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * math.pi;
          final isFront = _controller.value >= 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront ? _front() : _back(),
          );
        },
      ),
    );
  }

  Widget _front() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Text(widget.value, style: const TextStyle(fontSize: 40)),
        ),
      ),
    );
  }

  Widget _back() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
      child: const Center(
        child: Icon(Icons.question_mark, color: Colors.white, size: 36),
      ),
    );
  }
}
