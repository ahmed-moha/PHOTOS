import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photos/photos.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  List<PhotosModel> photos = [];
  Future<List<PhotosModel>> getPhotos() async {
    var response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      for (var element in decodedData) {
        photos.add(PhotosModel.fromJson(element));
      }
    }

    return photos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PHOTOS'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<PhotosModel>>(
        future: getPhotos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PhotosModel> data = snapshot.data!;
            return ListView.builder(
              itemBuilder: (context, index) => Container(
                 margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: Container(
                   
                    child: Image.network(data[index].thumnailUrl ?? ""),
                  ),
                   title: Text(data[index].title??""),
                  trailing: Text(data[index].id.toString()),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
