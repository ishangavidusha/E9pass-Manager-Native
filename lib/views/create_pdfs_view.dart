import 'package:e9pass_manager/service/file_service.dart';
import 'package:e9pass_manager/service/image_servise.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/views/image_edit_view.dart';
import 'package:e9pass_manager/widgets/get_files_ui.dart';
import 'package:e9pass_manager/widgets/kbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePDFs extends StatefulWidget {
  @override
  _CreatePDFsState createState() => _CreatePDFsState();
}

class _CreatePDFsState extends State<CreatePDFs> {
  FileService _fileService;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width - 200;
    double devHeight = MediaQuery.of(context).size.height;
    _fileService = Provider.of<FileService>(context);
    return Container(
      width: devWidth,
      height: devHeight,
      child: _fileService.pickedImages.isEmpty ? GetFilesUI(
        onPressed: () {
          _fileService.getImageFiles(false);
        }
      ) : Column(
        children: [
          SizedBox(
            height: 29,
          ),
          Container(
            width: devWidth,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Text(
                  'PDF File Create',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                    color: AppColors.textColor
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: devWidth,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
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
                  child: Image.asset('assets/icons/042-folder.png', scale: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Images',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                        color: AppColors.textColor
                      ),
                    ),
                    Text(
                      '${_fileService.pickedImages.length} Image Selected',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: AppColors.textColor
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                Transform.scale(
                  scale: 0.8,
                  child: KButton(
                    text: 'Add More',
                    onPressed: () {
                      _fileService.getImageFiles(true);
                    },
                    selected: false,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.secondTextColor,),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (devWidth ~/ 100) - 2,
                childAspectRatio: 1.4
              ),
              itemCount: _fileService.pickedImages.isNotEmpty ? _fileService.pickedImages.length : 0,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () async {
                      // Go to edit
                      Provider.of<ImageService>(context, listen: false).clear();
                      Provider.of<ImageService>(context, listen: false).setImage(_fileService.pickedImages[index]);
                      bool edited = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImageEditView()),
                      );
                      if (edited) {
                        _fileService.pickedImages[index].bytes = Provider.of<ImageService>(context, listen: false).getImage();
                        _fileService.pickedImages[index].raw = false;
                      } else {
                        _fileService.pickedImages[index].bytes = Provider.of<ImageService>(context, listen: false).getOriginal();
                        _fileService.pickedImages[index].raw = true;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: _fileService.pickedImages[index].raw ? Color(0xff6e5ced) : Colors.red
                        )
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(_fileService.pickedImages[index].bytes, fit: BoxFit.cover,),
                      ),
                    ),
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}