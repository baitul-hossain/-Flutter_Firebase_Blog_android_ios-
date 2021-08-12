
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods{

  Future<void> addData(blogData) async{

    await FirebaseFirestore.instance.collection("blogs").add(blogData).catchError((e){print(e);});
  }
}