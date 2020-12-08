import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class KButton extends StatefulWidget {
  final Function onPressed;
  final String text;
  final bool selected;
  final Function onPointerHover;

  const KButton({Key key, this.onPressed, this.text, this.selected = false, this.onPointerHover}) : super(key: key);

  @override
  _KButtonState createState() => _KButtonState();
}

class _KButtonState extends State<KButton> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: MouseRegion(
        onEnter: (event) {
          if (widget.onPointerHover != null) {
            widget.onPointerHover(true);
          }
          setState(() {
            selected = true;
          });
        },
        onExit: (event) {
          if (widget.onPointerHover != null) {
            widget.onPointerHover(false);
          }
          setState(() {
            selected = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: selected ? AppColors.selectedBtColor.withOpacity(0.2) : AppColors.btColor.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(0, 3)
              )
            ]
          ),
          child: FlatButton(
            onPressed: widget.onPressed,
            child: Text(
              widget.text,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            textTheme: ButtonTextTheme.primary,
            textColor: AppColors.bgColor,
            color:selected ? AppColors.selectedBtColor : AppColors.btColor,
            clipBehavior: Clip.antiAlias,
            disabledColor: AppColors.secondTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
      ),
    );
  }
}