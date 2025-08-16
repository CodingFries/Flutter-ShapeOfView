import 'package:flutter/material.dart';
import 'package:kenburns_nullsafety/kenburns_nullsafety.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

/// Example page demonstrating various ShapeOfView implementations.
///
/// This page showcases different shape types available in the ShapeOfView package,
/// including diagonal shapes, circles, rounded rectangles, cut corners, arcs,
/// triangles, bubbles, stars, and polygons.
class JacksmanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShapeOfView(
          elevation: 4,
          height: 300,
          shape: DiagonalShape(
            angle: DiagonalAngle.deg(angle: 15),
          ),
          child: Stack(
            children: [
              KenBurns(
                maxScale: 5,
                child: Image.asset(
                  "assets/diagonallayout_background.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18, top: 120),
                    child: Text(
                      "Hugh Jackman",
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          fontSize: 20,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                blurRadius: 1,
                                offset: Offset(1, 1)),
                          ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 6.0),
                    child: Text(
                      "Actor Producer",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                blurRadius: 1,
                                offset: Offset(1, 1)),
                          ]),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        // Grid showcasing various shape types with different configurations
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 230),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              HelperWidget(
                shape: CircleShape(borderColor: Colors.white, borderWidth: 3),
              ),
              HelperWidget(
                shape: RoundRectShape(
                  borderRadius: BorderRadius.circular(12),
                  borderColor: Colors.white, //optional
                  borderWidth: 2, //optional
                ),
              ),
              HelperWidget(
                shape: CutCornerShape(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              HelperWidget(
                shape: ArcShape(
                  direction: ArcDirection.Outside,
                  height: 20,
                  position: ArcPosition.Bottom,
                ),
              ),
              HelperWidget(
                shape: DiagonalShape(
                  position: DiagonalPosition.Bottom,
                  direction: DiagonalDirection.Right,
                  angle: DiagonalAngle.deg(angle: 10),
                ),
              ),
              HelperWidget(
                shape: TriangleShape(
                  percentBottom: 0.5,
                  percentLeft: 0,
                  percentRight: 0,
                ),
              ),
              HelperWidget(
                shape: BubbleShape(
                  position: BubblePosition.Bottom,
                  arrowPositionPercent: 0.5,
                  borderRadius: 20,
                  arrowHeight: 10,
                  arrowWidth: 10,
                ),
              ),
              HelperWidget(
                shape: StarShape(noOfPoints: 5),
              ),
              HelperWidget(
                shape: PolygonShape(numberOfSides: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HelperWidget extends StatelessWidget {
  const HelperWidget({super.key, this.shape});

  /// The shape of the widget
  final Shape? shape;

  @override
  Widget build(BuildContext context) {
    return ShapeOfView(
      height: 100,
      width: 100,
      elevation: 2,
      shape: shape,
      child: Image.asset(
        "assets/diagonallayout_hughjackman.jpg",
        fit: BoxFit.cover,
      ),
    );
  }
}
