import 'dart:developer' as logging;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedBottomSheet extends StatefulWidget {
  final double minExpansion;
  final double maxExpansion;
  final Widget child;

  const AnimatedBottomSheet(
      {Key key,
      this.child,
      this.minExpansion = 0.1,
      this.maxExpansion = 0.6})
      : super(key: key);

  static _AnimatedBottomSheetState of(BuildContext context) => context.findAncestorStateOfType<_AnimatedBottomSheetState>();

  @override
  _AnimatedBottomSheetState createState() => _AnimatedBottomSheetState();

}

class _AnimatedBottomSheetState extends State<AnimatedBottomSheet> {
  bool _isExpanded = false;
  double _height;

  void collapse(){
    _isExpanded = false;
  }

  void expand(){
    _isExpanded = true;
  }

  @override
  Widget build(BuildContext context) {
    _height = _isExpanded
        ? MediaQuery.of(context).size.height *
        (1 - widget.maxExpansion)
        : MediaQuery.of(context).size.height *
        (1 - widget.minExpansion);

    return GestureDetector(
      onTap: () {
        logging.log("detected");
        setState(() {
          _isExpanded = false;
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.fromLTRB(0, _height, 0, 0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(color: Colors.white),
        child: widget.child,
      ),
    );
  }
}
