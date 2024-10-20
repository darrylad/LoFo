import 'package:flutter/material.dart';

class PulsingChild extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  const PulsingChild({super.key, required this.child, this.duration});

  @override
  State<PulsingChild> createState() => _PulsingChildState();
}

class _PulsingChildState extends State<PulsingChild>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration?.inMilliseconds ?? 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}
