import 'dart:convert';

import 'package:flutter_assignment/pages/tableStyle.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_assignment/pages/homepageListStyle.dart';

import 'model.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstScreen()//MyHomePage(title: 'An Invoice with Compensation'),
    );
  }
}
class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Way 2 Work", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body:  Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TableView()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                child: Text("Table View",style: TextStyle(color: Colors.white),),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(14.0))
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "List View of Invoice")));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                child: Text("List View",style: TextStyle(color: Colors.white),),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(14.0))
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
