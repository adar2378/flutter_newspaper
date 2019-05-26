import 'package:flutter/material.dart';

//https://www.uplabs.com/posts/news-mobile-app-uplabs-redesign-challenge design

class CollapsableAppBar extends StatefulWidget {
  final double appBarHeight;
  final Widget appBarChild;
  final Widget child;
  CollapsableAppBar(
      {@required this.appBarHeight, @required this.child, this.appBarChild});
  @override
  _CollapsableAppBarState createState() => _CollapsableAppBarState();
}

class _CollapsableAppBarState extends State<CollapsableAppBar> {
  double previousPosition, currentPosition;

  @override
  void initState() {
    height = widget.appBarHeight;
    super.initState();
  }

  double height;

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerMove: (opm) {
          print(opm.delta.dy);
          if (opm.delta.dy > 0) {
            if (height != widget.appBarHeight) {
              setState(() {
                height = widget.appBarHeight;
              });
            }
          } else if (opm.delta.dy < 0) {
            print("here in 2nd");
            if (height != 0) {
              setState(() {
                height = 0;
              });
            }
          }
        },
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            AnimatedContainer(
              color: Color(0xFFDA1057),
              height: height,
              child: Column(
                children: <Widget>[
                  Expanded(child: widget.appBarChild),
                ],
              ),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
            AnimatedContainer(
                height: MediaQuery.of(context).size.height - height,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: widget.child)
          ],
        ));
  }
}
