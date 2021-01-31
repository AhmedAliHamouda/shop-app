import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UploadImageToFireBase extends StatefulWidget {

  @override
  _UploadImageToFireBaseState createState() => _UploadImageToFireBaseState();
}

class _UploadImageToFireBaseState extends State<UploadImageToFireBase> {
  File _imageFile;
  FirebaseStorage _storage = FirebaseStorage.instance;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile == null) {
      return;
    } else {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    String fileName=basename(_imageFile.path);
    StorageReference reference = _storage.ref().child("images/$fileName");
    StorageUploadTask uploadTask =  reference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot= await uploadTask.onComplete;
    String downLoadUrl=  await taskSnapshot.ref.getDownloadURL();
    print(downLoadUrl);
    print('hey Iam here now');
  }

  Future<void> uploadImage() async {
    String fileName=basename(_imageFile.path);
    StorageReference reference = _storage.ref().child("images/$fileName");
    StorageUploadTask uploadTask =  reference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot= await uploadTask.onComplete;
    String downLoadUrl=  await taskSnapshot.ref.getDownloadURL();
    print(downLoadUrl);
    print('hey Iam here now');

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          //height: 40,
          //width: 100,
          constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
          alignment: Alignment.center,
          //margin: EdgeInsets.only(top: 15.0, right: 10.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageFile == null
              ? Text('No Image!')
              : SizedBox.expand(
                  child: FittedBox(
                    child: Image.file(_imageFile),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        SizedBox(
          width: 40.0,
        ),
        IconButton(
          icon: Icon(
            Icons.camera_alt,
            size: 30.0,
          ),
          onPressed: pickImage,
        ),
        SizedBox(
          width:20.0,
        ),
        IconButton(
          icon: Icon(
            Icons.cloud_upload,
            size: 30.0,
          ),
          onPressed: ()async{
            await uploadImage();
          },
        ),
      ],
    );
  }
}
