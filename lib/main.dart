import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:http/http.dart' as http;

class ImageResponse {
  final String file;
  const ImageResponse({
    required this.file,
  });

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
      file: json['file'],
    );
  }
}

Future<ImageResponse> fetchImage() async {
  final response = await http.get(Uri.parse('https://aws.random.cat/meow'));
  if (response.statusCode == 200) {
    return ImageResponse.fromJson(jsonDecode(response.body));
  }  else {
    throw Exception("Failed to load cat");
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late Future<ImageResponse> catImage;

  @override
  Widget build(BuildContext context) {
    var catImage = fetchImage();
    return MaterialApp(
        title: 'Random cat',
        theme:flutterNesTheme(),
        home:Scaffold(
          appBar: AppBar(
            title: const Text('Cat explorer'),
          ),
          body: Column(
          children: [ NesContainer(child: FutureBuilder<ImageResponse>(
              future: catImage,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.network(
                    snapshot.data!.file,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              }
          )),
        Divider()
      ])
         ,floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton:  NesButton(
    type: NesButtonType.normal,
        onPressed: () => setState(() {
      catImage = fetchImage();
    }),
    child: const Text("I want more!"),
    )
        )


    );
  }

}
