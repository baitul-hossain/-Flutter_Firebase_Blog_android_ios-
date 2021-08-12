

import 'package:flutter/material.dart';

import 'create_blog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
      body: Container(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.0
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
