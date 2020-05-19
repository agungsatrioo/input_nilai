import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.route
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final StatefulWidget route;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return route;
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}