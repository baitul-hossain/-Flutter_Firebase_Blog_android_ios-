
import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  //String downloadUrl, authorName, title, desc;
  TextEditingController authorName = new TextEditingController();
  TextEditingController title = new TextEditingController();
  TextEditingController desc = new TextEditingController();

  CrudMethods crudMethods = new CrudMethods();

  File selectedImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadBlog() async{
    if(selectedImage != null){
      // Upload image to Firebase storage
      firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().
    child('blogImages').child("${randomAlphaNumeric(9)}.jpg");

      firebase_storage.UploadTask task = firebaseStorageRef.putFile(io.File(selectedImage.path));

      var downloadUrl = await task.whenComplete(() => firebaseStorageRef.getDownloadURL());

      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(downloadUrl.ref.fullPath)
          .getDownloadURL();

      //print(downloadURL);

      Map<String, String> blogMap = {
        'imgUrl' : downloadURL,
        'authorName' : authorName.text,
        'title' : title.text,
        'desc' : desc.text
      };

      crudMethods.addData(blogMap).then((value){
        Navigator.pop(context);
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: (){
              uploadBlog();
            },
            child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0
                ),
                child: Icon(Icons.file_upload)
            ),
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter',
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white
              ),
            ),
            Text('Blog',
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.blueGrey
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox( height: 10.0,),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child:
              selectedImage != null ?
              Container(
                margin: EdgeInsets.all(16.0),
                height: 150.0,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(selectedImage, fit: BoxFit.cover,)
                ),
              ) : Container(
                margin: EdgeInsets.all(16.0),
                height: 150.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Icon(Icons.add_a_photo, color: Colors.blueGrey,),
              ),
            ),
            SizedBox(height: 8.0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Author Name'
                    ),
                    // onChanged: (val){
                    //   authorName = val;
                    // },
                    controller: authorName,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Title'
                    ),
                    // onChanged: (val){
                    //   title = val.to;
                    // },
                    controller: title,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Description'
                    ),
                    // onChanged: (val){
                    //   desc = val;
                    // },
                    controller: desc,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
