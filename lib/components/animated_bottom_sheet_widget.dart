import 'package:flutter/material.dart';

class AnimatedBottomSheet extends StatelessWidget {
  const AnimatedBottomSheet({
    Key key,
    @required this.controller,
    this.children,
    this.minChildSize = 0.1,
    this.maxChildSize = 0.7,
    this.initialChildSize = 0.3,
    this.padding = 20,
  }) : super(key: key);

  final AnimationController controller;
  final double minChildSize;
  final double maxChildSize;
  final double initialChildSize;
  final double padding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
          .animate(controller),
      child: DraggableScrollableSheet(
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        initialChildSize: initialChildSize,
        builder: (BuildContext context, ScrollController scrollController) {
          return AnimatedBuilder(
            animation: scrollController,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: LayoutBuilder(builder: (context, constraint) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: padding, top: padding, right: padding),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Gray bar at the very top of the sheet
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  alignment: Alignment.topCenter,
                                  width: 35,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).dividerColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }
}
