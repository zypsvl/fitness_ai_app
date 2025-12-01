import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;
  final bool showFloatingCircles;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF0A0E27),
      Color(0xFF1A1F38),
      Color(0xFF0F1229),
    ],
    this.duration = const Duration(seconds: 8),
    this.showFloatingCircles = true,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated Gradient Background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.colors,
                  stops: [
                    0.0,
                    0.5 + (_controller.value * 0.2),
                    1.0,
                  ],
                ),
              ),
            );
          },
        ),

        // Floating Circles
        if (widget.showFloatingCircles) ...[
          _buildFloatingCircle(
            top: -100,
            right: -100,
            size: 300,
            color: const Color(0xFFBB86FC),
            animation: _controller,
          ),
          _buildFloatingCircle(
            bottom: -50,
            left: -50,
            size: 250,
            color: const Color(0xFF03DAC6),
            animation: _controller,
            reverse: true,
          ),
          _buildFloatingCircle(
            top: 200,
            left: -80,
            size: 200,
            color: const Color(0xFFFF6EC7),
            animation: _controller,
            delay: 0.5,
          ),
        ],

        // Content
        widget.child,
      ],
    );
  }

  Widget _buildFloatingCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required Animation<double> animation,
    bool reverse = false,
    double delay = 0.0,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final value = reverse ? 1 - animation.value : animation.value;
          final delayedValue = ((value + delay) % 1.0);
          final scale = 1.0 + (math.sin(delayedValue * math.pi * 2) * 0.1);
          final opacity = 0.1 + (math.sin(delayedValue * math.pi * 2) * 0.05);

          return Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: opacity),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Particle> particles;

  ParticlesPainter({required this.animation, required this.particles})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      final progress = (animation.value + particle.offset) % 1.0;
      final x = particle.x * size.width;
      final y = particle.y * size.height + (progress * size.height * 0.5);
      final opacity = (1 - progress) * particle.opacity;

      paint.color = particle.color.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(x, y % size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double opacity;
  final double offset;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.opacity,
    required this.offset,
  });
}
