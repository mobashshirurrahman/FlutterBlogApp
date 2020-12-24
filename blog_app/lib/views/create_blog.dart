// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  TextEditingController authortextEditingController = TextEditingController();
  TextEditingController titletextEditingController = TextEditingController();
  TextEditingController desctextEditingController = TextEditingController();

  String imageUrl;
  bool isLoading = false;

  File _selectedImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  addBlog() async {
    // make sure we have an image
    if (_selectedImage != null) {
      setState(() {
        isLoading = true;
      });
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference =
          storage.ref().child("/blogImages/${randomAlphaNumeric(20)}.jpg");

      UploadTask uploadTask = storageReference.putFile(_selectedImage);

      await uploadTask.whenComplete(() async {
        try {
          imageUrl = await storageReference.getDownloadURL();
        } catch (e) {
          print(e);
        }
      });

      // upload image

      // get download url

      // create blog data map

      // upload to firebase

      Map<String, dynamic> blogData = {
        "auth": authortextEditingController.text,
        "dec": desctextEditingController.text,
        "title": titletextEditingController.text,
        "imgUrl": imageUrl,
        "time": DateTime.now().microsecond,
      };
      FirebaseFirestore.instance
          .collection("blog")
          .add(blogData)
          .catchError((onError) {
        print(onError);
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close)),
        title: Text("Create Blog"),
        actions: [
          InkWell(
            onTap: () {
              addBlog();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.file_upload),
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _selectedImage == null
                        ? GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.add_a_photo),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage,
                                  height: 180,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                )),
                          ),
                    TextField(
                      controller: authortextEditingController,
                      decoration: InputDecoration(hintText: "Author name"),
                    ),
                    TextField(
                      controller: titletextEditingController,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                    TextField(
                      controller: desctextEditingController,
                      decoration: InputDecoration(hintText: "Description"),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addBlog();
        },
        child: Icon(
          Icons.file_upload,
        ),
      ),
    );
  }
}
