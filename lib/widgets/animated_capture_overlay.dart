import 'package:flutter/material.dart';

class AnimatedCaptureOverlay extends StatefulWidget {
  final String assetPath;

  const AnimatedCaptureOverlay({Key? key, required this.assetPath}) : super(key: key);

  @override
  _AnimatedCaptureOverlayState createState() => _AnimatedCaptureOverlayState();
}

class _AnimatedCaptureOverlayState extends State<AnimatedCaptureOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Center(
        child: Image.asset(widget.assetPath),
      ),
    );
  }
}