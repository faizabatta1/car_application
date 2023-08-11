import 'package:car_app/helpers/theme_helper.dart';
import 'package:flutter/material.dart';

class SwipeToUnlockSwitch extends StatefulWidget {
  final VoidCallback onSwipeEnd;

  const SwipeToUnlockSwitch({super.key, required this.onSwipeEnd});

  @override
  _SwipeToUnlockSwitchState createState() => _SwipeToUnlockSwitchState();
}

class _SwipeToUnlockSwitchState extends State<SwipeToUnlockSwitch> {
  double _xOffset = 0;
  double _maxXOffset = 350;
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 25; // Calculate dynamic border radius

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _xOffset += details.delta.dx;
          if (_xOffset < 0) {
            _xOffset = 0;
          } else if (_xOffset > _maxXOffset) {
            _xOffset = _maxXOffset;
            _unlocked = true;

            widget.onSwipeEnd();
          }
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          if (!_unlocked) {
            _xOffset = 0;
          }
          if (_xOffset == 0) {
            _unlocked = false;
          }
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _unlocked ? Colors.green : ThemeHelper.buttonPrimaryColor,
                borderRadius: BorderRadius.circular(borderRadius), // Use the dynamic border radius
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      _unlocked ? 'Uploaded' : 'Swipe to Upload',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: _xOffset,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.chevron_right,
                  size: 50,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}