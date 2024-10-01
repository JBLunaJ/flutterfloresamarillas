import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramo de Girasol',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: FlowerBouquet(),
      ),
    );
  }
}

class FlowerBouquet extends StatefulWidget {
  @override
  _FlowerBouquetState createState() => _FlowerBouquetState();
}

class _FlowerBouquetState extends State<FlowerBouquet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.1, end: 0.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              size: Size(400, 400),
              painter: FlowerBouquetPainter(_animation.value),
            );
          },
        ),
        SizedBox(height: 20), // Espacio entre el dibujo y el texto
        Text(
          'Feliz primavera',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '❤️', // Corazón
          style: TextStyle(
            fontSize: 40, // Tamaño del corazón
            color: Colors.red, // Color rojo para el corazón
          ),
        ),
      ],
    );
  }
}

class FlowerBouquetPainter extends CustomPainter {
  final double swayOffset;

  FlowerBouquetPainter(this.swayOffset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final phi = 137.508 * (pi / 180.0);

    // Función para dibujar un girasol
    void drawFlower(double x, double y, double sizeFactor) {
      // Dibuja el tallo detrás de la flor
      paint.color = Colors.green;
      paint.style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(x - 2, y, 4, 100 * sizeFactor), paint);

      // Dibuja los pétalos con variación
      paint.color = Colors.yellow;
      for (int i = 0; i < 220; i++) {
        double r = sizeFactor * 4 * sqrt(i.toDouble());
        double theta = i * phi;
        double xPos = r * cos(theta);
        double yPos = r * sin(theta);
        // Variación en el tamaño de los pétalos
        double petalSize = 5 * sizeFactor;
        canvas.drawCircle(Offset(x + xPos + swayOffset * 30, y + yPos), petalSize, paint);
      }

      // Dibuja el centro de la flor
      paint.color = Colors.brown;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 20 * sizeFactor, paint);
    }

    // Posiciones y tamaños de las flores
    final positions = [
      Offset(100, 220),
      Offset(150, 180),
      Offset(200, 250),
      Offset(80, 150),
      Offset(250, 300),
      Offset(120, 290),
      Offset(50, 250),
      Offset(300, 200),
      Offset(170, 300),
      Offset(220, 100),
    ];
    final sizes = [
      0.6, 0.7, 0.5, 0.4, 0.6,
      0.5, 0.4, 0.7, 0.5, 0.6,
    ]; // Tamaños variados

    // Dibujar las flores
    for (int i = 0; i < positions.length; i++) {
      drawFlower(positions[i].dx, positions[i].dy, sizes[i]);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
