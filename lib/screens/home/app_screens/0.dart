import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:image/image.dart' as brendanImage;
import 'package:path/path.dart' as path;
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage0 extends StatelessWidget {
  String _progress = "-";
  final doc = pdf.Document();
  final heading = "DR Prescription Data";
  final description = "Your DR level : 0. You are free from DR";
  var image1;
  File a;
  List<File> _files = [];

  MyHomePage0(var image) {
    //List<File> temp = _files;
    //temp.add(image);
    //var b = image;
    //his.image1 = b as brendanImage.Image;
    //a = PdfImage.fromImage(doc.document, image: image1);
    //a = image;
    image1 =
        PdfImage.file(doc.document, bytes: File(image.path).readAsBytesSync());
  }


  writeOnPdf() {
    doc.addPage(pdf.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: pdf.EdgeInsets.all(32),
        build: (pdf.Context context) {
          return <pdf.Widget>[
            pdf.Center(
                child: pdf.Text(heading,
                    textAlign: pdf.TextAlign.center,
                    style: pdf.TextStyle(fontSize: 16.0))),
            pdf.SizedBox(height: 30.0),
            pdf.Image(image1),
            pdf.Text(description,
                textAlign: pdf.TextAlign.left,
                style: pdf.TextStyle(fontSize: 15.0)),
          ];
        }));
  }

  Future savePDF() async {
    Directory documentDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    ;
    String documentPath = documentDirectory.path;
    File file = new File("$documentPath/example.pdf");
    file.writeAsBytesSync(doc.save());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      RaisedButton(
        onPressed: () async {
          if (await Permission.storage.request().isGranted) {
            writeOnPdf();
            await savePDF();
          }

          Directory documentDirectory =
              await DownloadsPathProvider.downloadsDirectory;

          String documentPath = documentDirectory.path;

          String fullPath = "$documentPath/example.pdf";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfPreviewScreen(
                        path: fullPath,
                      )));
          if (await File(fullPath).exists()) {
            print("File exists");
          } else {
            print("No file exists");
          }
          var path = await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);
          print(path);
        },
        child: Text("Click to Continue"),
      ),
      SizedBox(
        height: 50.0,
      )
    ]));
  }
}
