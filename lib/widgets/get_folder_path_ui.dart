import 'package:dotted_border/dotted_border.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/widgets/kbutton.dart';
import 'package:flutter/material.dart';

class GetFolderUI extends StatelessWidget {
  final Function onPressed;

  const GetFolderUI({Key key, this.onPressed}) : super(key: key);
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
                'Select Source Folder',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1.2,
                  color: AppColors.textColor
                ),
              ),
              Spacer(),
              Container(
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
              SizedBox(
                height: 20,
              ),
              KButton(
                onPressed: onPressed,
                text: 'Open Folder',
                selected: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}