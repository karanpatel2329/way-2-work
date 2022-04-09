import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _baseUrl = 'http://134.213.212.195:3000/api/jobseeker/invoice';
  int _page = 0;
  int _limit = 5;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List modeldata = [];
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res =
      await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"),headers: {"x-access-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjgxLCJpc0NvbXBhbnkiOmZhbHNlLCJpc0pvYlNlZWtlciI6dHJ1ZSwiaWF0IjoxNjQ5NDc2Mjc4LCJleHAiOjE2NDk1NjI2Nzh9.NHK65uZLyqjGJZlzJQiLqAFIjqGPUQm2i67XC31i40Y"});
      var data =json.decode(res.body)['data'];
      for (var i in data){
        //print(i['status']);
        Model model = Model(status: "approved", createdAt: i['contract_date']??" ", dueDate: i['due_date']??" ", invoiceId: i['invoice_number']??" ", invoiceTo: i['company']['company_name']??" ", paymentStatus: i['payment_status']??" ", totalSum: i['sub_total'].toString()??" ");
        modeldata.add(model);
        print(model);
      }
      setState(() {
        modeldata = modeldata;
      });
    } catch (err) {
      print("ERR");
      print(err);
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        final res =
        await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"),headers: {"x-access-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjgxLCJpc0NvbXBhbnkiOmZhbHNlLCJpc0pvYlNlZWtlciI6dHJ1ZSwiaWF0IjoxNjQ5NDc2Mjc4LCJleHAiOjE2NDk1NjI2Nzh9.NHK65uZLyqjGJZlzJQiLqAFIjqGPUQm2i67XC31i40Y"});

        final fetchedPosts=[];

        var data =json.decode(res.body)['data'];
        print(json.decode(res.body));
        print("SSSsss");
        for (var i in data){
          //print(i['status']);
          Model model = Model(status: "approved", createdAt: i['contract_date']??" ", dueDate: i['due_date']??" ", invoiceId: i['invoice_number']??" ", invoiceTo: i['company']['company_name']??" ", paymentStatus: i['payment_status']??" ", totalSum: i['sub_total'].toString()??" ");
          fetchedPosts.add(model);
          print(model);
        }
        if (fetchedPosts.length > 0) {
          print("++++");
          print(fetchedPosts);
          setState(() {
            modeldata.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print("SSS");
        print(err);
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: _isFirstLoadRunning
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: modeldata.length,
              itemBuilder: (_, index) => Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(modeldata[index].createdAt==" "?"No Date Found":"Created Date :- "+modeldata[index].createdAt),
                            Text("Due Date :- "+modeldata[index].dueDate),
                            Text("Invoice Id :- "+modeldata[index].invoiceId),
                            Text("Invoice To :- "+modeldata[index].invoiceTo),
                            Text("Status :- "+modeldata[index].status),
                            Text("Payment Status :- "+modeldata[index].paymentStatus),
                            Text("Total Sum :- € "+modeldata[index].totalSum,style: TextStyle(fontWeight: FontWeight.bold),)


                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              child: Icon(Icons.copy_outlined,color: Colors.red,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              child: Icon(Icons.preview_outlined,color: Colors.red,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              child: Icon(Icons.edit,color: Colors.red,),
                            )
                          ],
                        )
                      ],
                    ),
                  )
              ),
            ),
          ),

          // when the _loadMore function is running
          if (_isLoadMoreRunning == true)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // When nothing else to load
          if (_hasNextPage == false)
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 40),
              color: Colors.amber,
              child: Center(
                child: Text('You have fetched all of the content'),
              ),
            ),
        ],
      ),
    );
  }
}
