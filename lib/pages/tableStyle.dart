import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model.dart';
class TableView extends StatefulWidget {
  const TableView({Key? key}) : super(key: key);

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final _baseUrl = 'http://134.213.212.195:3000/api/jobseeker/invoice';

  int _page = 0;
  final int _limit = 15;

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
          String status =i['approved']==true?"approved":"Not approved";
          Model model = Model(status: status, createdAt: i['contract_date']??" ", dueDate: i['due_date']??" ", invoiceId: i['invoice_number']??" ", invoiceTo: i['company']['company_name']??" ", paymentStatus: i['payment_status']??" ", totalSum: i['sub_total'].toString()??" ");
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
          // This means there is no more data
          // and therefore, we will not send another GET request
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

  // The controller for the ListView
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
        title: Text("Table View", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: GestureDetector(
                onTap: (){
                  _loadMore();
                },
                child: Text("Load More"),
              ),
            ),
          ),
        ],
      ),
      body: _isFirstLoadRunning
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        width: width*1.6,
        child: Column(

          children: [
            Table(
              columnWidths: {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
                6: FlexColumnWidth(2),
              },
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  children:[
                    Text("Created",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                    Text("Due Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                    Text("Invoice Id",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                    Text("Invoice To",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                    Text("Status",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                    Text("Payment Status",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                    Text("Total",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),)
                  ]
              ),
            ],
            ),
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: modeldata.length,
                itemBuilder: (_, index) => Table(
                  columnWidths: {
                    0: FlexColumnWidth(2.5),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                    5: FlexColumnWidth(2),
                    6: FlexColumnWidth(2),
                  },
                  border: TableBorder.all(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                        children:[
                          Text(modeldata[index].createdAt==" "?"No Date Found":modeldata[index].createdAt,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                          Text(modeldata[index].dueDate,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                          Text(modeldata[index].invoiceId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                          Text(modeldata[index].invoiceTo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                          Container(color:modeldata[index].status=="approved"?Colors.green:modeldata[index].status=='waiting'?Colors.yellow:Colors.red,child: Text(modeldata[index].status,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),)),
                          Text(modeldata[index].paymentStatus,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                          Text(modeldata[index].totalSum,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),)

                        ]
                    )
                  ],

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
      ),
    );
  }
}

