import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase detect faces in images',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _facesDetected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Run on real iOS device and no faces are found',
              ),
            ),
            Text(
              'Count of faces detected',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '$_facesDetected',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _process,
        tooltip: 'Detect Faces',
        icon: Icon(Icons.face),
        label: Text('Detect faces'),
      ),
    );
  }

  Future<void> _process() async {
    final imageFile = await _getImageFile();
    await _detectFaces(imageFile);
  }

  Future<File> _getImageFile() async {
    final imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    return File(imageFile.path);
  }

  Future<void> _detectFaces(File imageFile) async {
    FaceDetector faceDetector;
    try {
      faceDetector = FirebaseVision.instance.faceDetector();
      final List<Face> faces = await faceDetector.processImage(
        FirebaseVisionImage.fromFile(
          imageFile,
        ),
      );
      setState(() {
        _facesDetected = faces.length;
      });
    } finally {
      faceDetector?.close();
    }
  }
}
