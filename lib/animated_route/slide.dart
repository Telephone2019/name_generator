import 'package:flutter/material.dart';

/// @thanks https://medium.com/flutter-community/everything-you-need-to-know-about-flutter-page-route-transition-9ef5c1b32823
class SlideRoute extends PageRouteBuilder {
  final Widget page;
  final double beginX;
  final double beginY;
  final double endX;
  final double endY;
  SlideRoute({this.beginX, this.beginY, this.endX, this.endY, this.page})
      : super(
          pageBuilder: (context, animationDouble, secondaryAnimationDouble) =>
              page,
          transitionsBuilder: (context, animationDouble,
                  secondaryAnimationDouble, childWidget) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: Offset(beginX, beginY),
              end: Offset(endX, endY),
            ).animate(animationDouble),
            child: childWidget,
          ),
        );
  SlideRoute.slideIn({double beginX, double beginY, Widget page})
      : this(
          beginX: beginX,
          beginY: beginY,
          endX: 0,
          endY: 0,
          page: page,
        );
  SlideRoute.slideOut({double endX, double endY, Widget page})
      : this(
          beginX: 0,
          beginY: 0,
          endX: endX,
          endY: endY,
          page: page,
        );
  SlideRoute.slideInLeft({Widget page})
      : this.slideIn(
          beginX: -1,
          beginY: 0,
          page: page,
        );
  SlideRoute.slideInRight({Widget page})
      : this.slideIn(
          beginX: 1,
          beginY: 0,
          page: page,
        );
  SlideRoute.slideInTop({Widget page})
      : this.slideIn(
          beginX: 0,
          beginY: -1,
          page: page,
        );
  SlideRoute.slideInBottom({Widget page})
      : this.slideIn(
          beginX: 0,
          beginY: 1,
          page: page,
        );
}
