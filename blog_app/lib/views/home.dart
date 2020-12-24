import 'package:blog_app/views/create_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getBlog() {}

  Widget blogList() {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("blog")
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Error ${snapshot.hasError}");
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text("loading...");

              break;
            default:
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  // return Text(snapshot.data.docs[index]["title"]);
                  return BlogTile(
                    imgUrl: snapshot.data.docs[index]["imgUrl"],
                    title: snapshot.data.docs[index]["title"],
                    desc: snapshot.data.docs[index]["dec"],
                    authorName: snapshot.data.docs[index]["auth"],
                  );
                },
              );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🔥Blog'),
      ),
      body: blogList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateBlog()));
          },
          child: Icon(Icons.upload_file)),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imgUrl, title, desc, authorName;
  BlogTile({this.imgUrl, this.title, this.desc, this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imgUrl,
            height: 180,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(title),
        SizedBox(
          height: 3,
        ),
        Text("$desc by $authorName"),
        SizedBox(
          height: 16,
        ),
      ],
    ));
  }
}
