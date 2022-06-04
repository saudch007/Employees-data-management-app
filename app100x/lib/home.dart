import 'dart:core';
import 'dart:io';
import 'package:app100x/search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:excel/excel.dart';
import 'package:app100x/getuser.dart';

// @dart=2.9
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  UploadTask? task;
  File? file;
  FirebaseStorage storage = FirebaseStorage.instance;
  String fileContents = "no data";
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No file selected';

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Center(
        child: Container(
          child: Center(
              child: ListView(children: [
            Text(
              '',
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    debugPrint('Upload file Clicked');
                    uploadFile();
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text(
                    "Upload file",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                )),
            Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    debugPrint('Select file Clicked');
                    selectFile();
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text(
                    "Select file",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                )),
            Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ///
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text(
                    "Add user in excel",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                )),
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                "",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  createExcel();
                },
                icon: Icon(Icons.add, size: 18),
                label: Text(
                  "Generate Excel",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => searchdata()),
                  );
                  // Respond to button press
                },
                icon: Icon(Icons.add, size: 18),
                label: Text(
                  "Search",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              ),
            ),
          ])),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }

// upload file method
  Future uploadFile() async {
    if (file == null) return;
    final fileName = file!.path;
    final destination = '$fileName';

    FirebaseApi.uploadFile(destination, file!);
  }

  basename(String path) {}
}
//read data

// class dealing with file upload
class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print("Error in class");
    }
  }
}

// excel //
Future<void> createExcel() async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  sheet.getRangeByName('A1').setText(
        usernameController.text.toString(),
      );
  sheet.getRangeByName('A2').setText(
        emailController.text.toString(),
      );
  sheet.getRangeByName('A3').setText(
        phoneController.text.toString(),
      );
  sheet.getRangeByName('A4').setText(
        passwordController.text.toString(),
      );

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName =
      Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open(fileName);
}

// save //


