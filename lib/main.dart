import 'dart:io';

import 'package:camera/photo_view.dart';
import 'package:camera/splash.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.indigo),
      home:const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> _img = []; //For desplay image on UI
  final ImagePicker _imagePicker = ImagePicker();

//image getting from camera
  Future<void> imageGetting() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final folder = Directory('${directory.path}/myImages');

      if (!(await folder.exists())) {
        await folder.create();
      }

      final String fileName = basename(image.path);
      final File newImage =
          await File(image.path).copy('${folder.path}/$fileName');
      setState(() {
        _img.add(newImage); // Add the new image to the list, not the old one
      });
    }
  }

  //Loading data
  Future<void> loadingData() async {
    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/myImages');

    if (await folder.exists()) {
      final allItems = folder.listSync();
      final files = allItems.where((item) => item is File);
      final fileObjects = files.map((item) => File(item.path));
      final imageFile = fileObjects.toList();
      setState(() {
        _img = imageFile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imageGetting();
        },
        child: const Icon(Icons.camera_alt),
      ),
      appBar: AppBar(
        title: const Text("Gallery"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return PhotoView(img: _img, index: index);
                }));
              },
              child: Card(
                child: Image(
                  image: FileImage(_img[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: _img.length,
      ),
    );
  }
}
