// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/Gif.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

//https://devjaime.medium.com/visual-studio-code-para-el-desarrollo-de-flutter-256dbd13b453

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<List<Gif>> _listadoGifs;
  Future<List<Gif>> _getGifs() async {
    final response=await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=Yu51UCivHnbJtoYFE1ScIUN2eCoOt5rv&limit=25&offset=0&rating=g&bundle=messaging_non_clips"));
    List<Gif> gifs=[];
    if (response.statusCode==200) {
      String body =utf8.decode(response.bodyBytes);
      final jsonData=jsonDecode(body);
      for (var element in jsonData["data"]) {
        gifs.add(Gif(name: '${element["title"]}',url:'${element["images"]["fixed_width_small"]["url"]}',));
      }
    } else {
      throw Exception("Fallo la conexión");
    }

    return gifs;

  }


  @override
  void initState() {
    super.initState();
    _listadoGifs=_getGifs();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: FutureBuilder(
          future: _listadoGifs,
          builder: (context,snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                children: _listGifs(snapshot.data!),
              );
            } else if(snapshot.hasError){
              print(snapshot.error);
              return Text("error");
            }
          return const Center(
            child: CircularProgressIndicator(),
          );
          },
        ),
      ),
    );
  }
  List<Widget> _listGifs(List<Gif> data){
     List<Widget> gifs=[];
     for (var element in data) {
      gifs.add(Card(child: Column(
        children: [
          Expanded(child: Image.network(element.url,fit: BoxFit.fill,)),
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(element.name),
          ),*/
        ],
      )));
     }
    return gifs;
  }
}


