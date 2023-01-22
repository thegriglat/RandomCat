import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:http/http.dart' as http;
import 'package:random_cat/models/cat_fact.dart';

import 'models/cat_image.dart';
import 'widgets/cat_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<CatImage> catImage;
  late Future<CatFact> catFact;
  late bool apiLoaded = false;

  @override
  void initState() {
    super.initState();
    updateState();
  }

  void updateState() {
    catImage = fetchImage();
    catFact = fetchFact();
  }

  Future<CatImage> fetchImage() async {
    apiLoaded = false;
    final response = await http.get(Uri.parse(catImageUrl));
    if (response.statusCode == 200) {
      apiLoaded = true;
      return CatImage.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load cat");
    }
  }

  Future<CatFact> fetchFact() async {
    final response = await http.get(Uri.parse(catFactUrl));
    if (response.statusCode == 200) {
      apiLoaded = true;
      return CatFact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load cat");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Random cat',
        theme: flutterNesTheme(),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Cat explorer'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 10 ),
                    child: NesContainer(
                        child: FutureBuilder<CatImage>(
                            future: catImage,
                            builder: (context, snapshot) {
                              if (!apiLoaded) {
                                return const Text("Cat almost ready...");
                              }
                              if (snapshot.hasData) {
                                return CatImageWidget(url: snapshot.data!.file);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              // By default, show a loading spinner.
                              return const CircularProgressIndicator();
                            }))),
                FutureBuilder<CatFact>(
                    future: catFact,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10
                        ),
                            child: Text(snapshot.data!.text,));
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    })
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: NesButton(
              type: NesButtonType.success,
              onPressed: () => setState(updateState),
              child: const Text("I want more!"),
            )));
  }
}
