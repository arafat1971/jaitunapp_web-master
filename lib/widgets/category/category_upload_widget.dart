import 'dart:html';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:shapeyouadmin_web/services/firebase_services.dart';


class CategoryCreateWidget extends StatefulWidget {
  @override
  _CategoryCreateWidgetState createState() => _CategoryCreateWidgetState();
}

class _CategoryCreateWidgetState extends State<CategoryCreateWidget> {

  FirebaseServices _services = FirebaseServices();
  var _fileNameTextController = TextEditingController();
  var _categoryNameTextController = TextEditingController();
  bool _visible = false;
  bool _imageSelected = true;
  String _url;

  @override
  Widget build(BuildContext context) {

    ProgressDialog progressDialog = ProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF84c225).withOpacity(.3),
        transitionDuration: Duration(milliseconds: 500));

    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: _categoryNameTextController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black, width: 1),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'No category Name given',
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.only(left: 20)),
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                          width: 200,
                          height: 30,
                          child: TextField(
                            controller: _fileNameTextController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'No image selected',
                                border: OutlineInputBorder(),
                                contentPadding:
                                EdgeInsets.only(left: 20)),
                          )),
                    ),
                    FlatButton(
                      child: Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        uploadStorage();
                      },
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: FlatButton(
                        child: Text(
                          'Save New Category',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if(_categoryNameTextController.text.isEmpty){
                            return _services.showMyDialog(
                                context: context,
                                title: 'Add New Category',
                                message: 'New Category Name not given'
                            );
                          }
                          progressDialog.show();
                          _services.uploadCategoryImageToDb(_url, _categoryNameTextController.text).then((downloadUrl) {
                            if(downloadUrl!=null){
                              progressDialog.dismiss();
                              _services.showMyDialog(
                                  title: 'New Category',
                                  message: 'Saved New Category Successfully',
                                  context: context
                              );
                            }
                          });
                          _categoryNameTextController.clear();
                          _fileNameTextController.clear();
                        },
                        color: _imageSelected ? Colors.black12 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _visible ?false : true,
              child: FlatButton(
                color: Colors.black54,
                child: Text('Add New Category',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  setState(() {
                    _visible = true;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()
      ..accept = 'image/*'; //it will upload only image
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });

    //selected image
  }

  void uploadStorage() {
    //upload selected image to Firebase storage
    final dateTime = DateTime.now();
    final path = 'CategoryImage/$dateTime';
    uploadImage(onSelected: (file) {
      if (file != null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected=false;
          _url = path;
        });
        fb.storage().refFromURL('gs://shapeyou-42b8c.appspot.com').child(path).put(file);
      }
    });
  }

}
