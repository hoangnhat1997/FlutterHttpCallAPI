import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview_coding_app/detailScreen.dart';
import 'package:interview_coding_app/modelPost.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Post> items = [];

  Future<void> getDataApi() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await http.get(url);
    final jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        items = (jsonData as List).map((item) => Post.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load Post');
    }
  }

  Future<void> postDataApi() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "title": "Nhat",
        }));
    print(response.body);
  }

  @override
  void initState() {
    getDataApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 40,
            child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  postDataApi();
                }),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 40,
            child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailScreen()));
                }),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) =>
                  Text(items[index].title),
            ),
          )
        ],
      )),
    );
  }
}
