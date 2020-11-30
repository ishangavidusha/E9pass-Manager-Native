import 'package:dotted_border/dotted_border.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/widgets/kbutton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GetFilesUI extends StatefulWidget {
  final Function onPressed;

  const GetFilesUI({Key key, this.onPressed}) : super(key: key);

  @override
  _GetFilesUIState createState() => _GetFilesUIState();
}

class _GetFilesUIState extends State<GetFilesUI> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  bool hover = false;

  initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this, value: 0.6, upperBound: 1.0, lowerBound: 0.6);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        radius: Radius.circular(20),
        strokeCap: StrokeCap.round,
        dashPattern: [8, 2, 1],
        strokeWidth: 4,
        color: AppColors.secondTextColor,
        child: Container(
          width: 550,
          height: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: AppColors.linearGradient
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Select Image Files',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1.2,
                  color: AppColors.textColor
                ),
              ),
              Spacer(),
              Transform.scale(
                scale: 1.2,
                child: ScaleTransition(
                  scale: _animation,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFC200).withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 4,
                          offset: Offset(0, 4)
                        )
                      ]
                    ),
                    child: Image.asset('assets/icons/042-folder.png', scale: 6),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              KButtonWithAnimation(
                onPressed: widget.onPressed,
                text: 'Open Files',
                selected: false,
                onPointerHover: (bool pointer) {
                  print(pointer);
                  if (pointer && !hover) {
                    setState(() {
                      hover = true;
                    });
                    _animationController.forward();
                  } else if (!pointer && hover) {
                    setState(() {
                      hover = false;
                    });
                    _animationController.reverse();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}