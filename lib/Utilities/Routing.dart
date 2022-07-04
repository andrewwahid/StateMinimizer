import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisRoute<T> extends PageRoute<T> {
  SharedAxisRoute({this.duration, this.builder }) : super();

  final WidgetBuilder builder;
  final Duration duration;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => "";

  @override
  Duration get transitionDuration => duration ?? const Duration(milliseconds: 800);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.01);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SharedAxisTransition(
      fillColor: Theme.of(context).cardColor,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.vertical,
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

}