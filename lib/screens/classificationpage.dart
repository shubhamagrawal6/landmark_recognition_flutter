import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:landmark_recognition_flutter/models/landmark.dart';
import 'package:landmark_recognition_flutter/services/classification_service.dart';
import 'package:landmark_recognition_flutter/services/image_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassificationPage extends StatefulWidget {
  final Landmark landmark;

  const ClassificationPage({this.landmark});
  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  ImageService _imageService;
  ClassificationService _classificationService;
  Uint8List userImage;
  List<dynamic> result = [];

  @override
  void initState() {
    super.initState();
    _classificationService = ClassificationService(
      modelPath: widget.landmark.model,
      labelPath: widget.landmark.label,
    );
    _imageService = ImageService();
  }

  @override
  void dispose() {
    super.dispose();
    _classificationService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          title: Text(widget.landmark.title),
        ),
        body: Stack(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: userImage == null
                      ? AssetImage(widget.landmark.image)
                      : MemoryImage(userImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
              margin: EdgeInsets.only(top: 340),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What is this landmark?",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    userImage == null
                        ? Text(
                            'No image selected.',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < result.length; i++)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${i + 1}. ${result[i]['label']}'),
                                          Text(
                                            '${result[i]['value']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _launchURL(result[i]['label']),
                                      child: Text('Search'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 310),
              alignment: Alignment.topCenter,
              child: Container(
                height: 80,
                width: 80,
                child: RawMaterialButton(
                  onPressed: () async {
                    var imageData = await _imageService.loadImage();
                    var classification = classify(imageData);
                    setState(() {
                      userImage = imageData;
                      result = classification;
                    });
                  },
                  elevation: 4,
                  fillColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.camera,
                    size: 35,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> classify(imageData) {
    if (imageData == null) {
      return [];
    } else {
      return _classificationService.runClassification(
        imageData: imageData,
        resultCount: 10,
      );
    }
  }

  void _launchURL(String landmark) async {
    var url = 'https://google.com/search?q=${landmark.replaceAll(' ', '_')}';
    url = Uri.encodeFull(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
