import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:flutter/material.dart';

class DrowerButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool selected;

  const DrowerButton({Key key, this.onPressed, this.text, this.selected = false}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          onPressed: onPressed,
          child: Text(
            text,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
      ),
    );
  }
}