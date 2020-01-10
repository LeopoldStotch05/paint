import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<List<Points>> _pointsList = [List<Points>()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paint'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_pointsList.isNotEmpty) {
                setState(() {
                  _pointsList.removeLast();
                });
              }
            },
            icon: Icon(Icons.settings_backup_restore),
          ),
          IconButton(
            onPressed: () {
              if (_pointsList.isNotEmpty) {
                setState(() {
                  _pointsList.clear();
                });
              }
            },
            icon: Icon(Icons.remove_circle),
          ),
        ],
      ),
      body: Painter(_pointsList),
    );
  }
}

class Painter extends StatefulWidget {
  final List<List<Points>> pointsList;

  const Painter(this.pointsList);

  @override
  _PainterState createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  Color selectedColor = Colors.black;
  double strokeWidth = 4.0;

  List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (dragStartDetails) {
        setState(() {
          List<Points> points = [];
          points.add(
            Points(
              paint: Paint()
                ..color = selectedColor
                ..isAntiAlias = true
                ..strokeWidth = strokeWidth,
              points: dragStartDetails.localPosition,
            ),
          );
          widget.pointsList.add(points);
        });
      },
      onPanUpdate: (dragStartDetails) {
        setState(() {
          widget.pointsList.last.add(
            Points(
              paint: Paint()
                ..color = selectedColor
                ..isAntiAlias = true
                ..strokeWidth = strokeWidth,
              points: dragStartDetails.localPosition,
            ),
          );
        });
      },
      onPanEnd: (dragStartDetails) {
        setState(() {
          widget.pointsList.last.add(null);
        });
      },
      child: CustomPaint(
        painter: MyPainter(widget.pointsList),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: colors[0],
                onPressed: () {
                  selectedColor = colors[0];
                },
              ),
              FloatingActionButton(
                backgroundColor: colors[1],
                onPressed: () {
                  selectedColor = colors[1];
                },
              ),
              FloatingActionButton(
                backgroundColor: colors[2],
                onPressed: () {
                  selectedColor = colors[2];
                },
              ),
              Slider(
                value: strokeWidth,
                onChanged: (newStrokeWidth) {
                  setState(() {
                    strokeWidth = newStrokeWidth;
                  });
                },
                max: 16,
                min: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<List<Points>> pointsList;

  MyPainter(this.pointsList);

  @override
  void paint(Canvas canvas, Size size) {
    pointsList.forEach((List<Points> points) {
      for (var index = 0; index < points.length - 1; index++) {
        if (points[index] != null && points[index + 1] != null) {
          canvas.drawLine(points[index].points, points[index + 1].points, points[index].paint);
          // final path = Path()
          //   ..moveTo(points[index].points.dx, points[index].points.dy)
          //   ..lineTo(points[index + 1].points.dx, points[index + 1].points.dy);
          // canvas.drawPath(path, points[index].paint);
        } else if (points[index] != null && points[index + 1] == null) {
          canvas.drawPoints(
              PointMode.points, [points[index].points], points[index].paint);
        }
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter old) => true;
}

class Points {
  Paint paint;
  Offset points;
  Points({this.points, this.paint});
}
