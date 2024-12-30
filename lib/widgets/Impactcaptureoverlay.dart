import 'package:flutter/material.dart';

class ImpactCaptureOverlay extends StatefulWidget {
  final String assetPath;

  const ImpactCaptureOverlay({Key? key, required this.assetPath}) : super(key: key);

  @override
  _ImpactCaptureOverlayState createState() => _ImpactCaptureOverlayState();
}

class _ImpactCaptureOverlayState extends State<ImpactCaptureOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Image.asset(widget.assetPath),
      ),
    );
  }
}