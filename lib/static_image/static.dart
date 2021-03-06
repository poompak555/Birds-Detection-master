import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:birds_detection/screens/details.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:birds_detection/util/data.dart';
import 'package:time/time.dart';
import 'package:image/image.dart' as imageLib;

List<XFile> pickedFile =
    []; //await picker.pickImage(source: ImageSource.gallery);

class StaticImage extends StatefulWidget {
  @override
  _StaticImageState createState() => _StaticImageState();
}

String detectedClass;
var index;
final Map bird = birds.asMap();

class _StaticImageState extends State<StaticImage> {
  File _image;
  List _recognitions;
  bool _busy;
  double _imageWidth, _imageHeight;
  bool detected = false;

  final picker = ImagePicker();

  // this function loads the model
  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/model_notB/model_notB.tflite",
      labels: "assets/model_notB/labels_notB.txt",
    );
  }

  // this function detects the objects on the image
  detectObject(File image) async {
    var start_time = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, // // required
        // path: 'assets/test/1.',
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5, // defaults to 0.1
        numResultsPerClass: 11, // defaults to 5
        asynch: true // defaults to true
        );
    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));
    setState(() {
      _recognitions = recognitions;
    });
    detected = true;
    var end_time = DateTime.now().millisecondsSinceEpoch;
    // print( "Time =  "+ (end_time - start_time).toString());
  }

  @override
  void initState() {
    super.initState();
    _busy = true;
    loadTfModel().then((val) {
      {
        setState(() {
          _busy = false;
        });
      }
    });
  }

  route(detectlass) {
    check(detectlass);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Details(
                  birdIndex: index,
                  pageIndex: "static",
                )));
  }

  void check(detectclass) {
    if (detectclass == "NICOBAR PIGEON") {
      index = 0;
    } else if (detectclass == "ALEXANDRINE PARAKEET") {
      index = 1;
    } else if (detectclass == "PEACOCK") {
      index = 2;
    } else if (detectclass == "HOOPOES") {
      index = 3;
    } else if (detectclass == "GREY PLOVER") {
      index = 4;
    } else if (detectclass == "PELICAN") {
      index = 5;
    } else if (detectclass == "WHIMBREL") {
      index = 6;
    } else if (detectclass == "CANARY") {
      index = 7;
    } else if (detectclass == "GREEN JAVAN MAGPIE") {
      index = 8;
    } else if (detectclass == "BARN OWL") {
      index = 9;
    } else if (detectclass == "NOTBIRD") {
      index = -1;
    }
  }

  // display the bounding boxes over the detected objects
  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;

    Color blue = Colors.blue;

    return _recognitions.map((re) {
      detectedClass = re["detectedClass"];
      if (detectedClass == "NOTBIRD") {
        return Container();
      } else if (detectedClass == "BARN OWL") {
        return Container(
          child: Positioned(
              left: re["rect"]["x"] * factorX - 50,
              top: (re["rect"]["y"] * factorY) + 100,
              width: re["rect"]["w"] * factorX,
              height: re["rect"]["h"] * factorY,
              child: ((re["confidenceInClass"] > 0.50))
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: blue,
                        width: 3,
                      )),
                      child: InkWell(
                        onTap: () {
                          route(re["detectedClass"]);
                        },
                        child: Text(
                          "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            background: Paint()..color = blue,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  : Container()),
        );
      } 
      else if (detectedClass == "CANARY") {
        return Container(
          child: Positioned(
              left: re["rect"]["x"] * factorX - 50,
              top: (re["rect"]["y"] * factorY) + 100,
              width: re["rect"]["w"] * factorX,
              height: re["rect"]["h"] * factorY,
              child: ((re["confidenceInClass"] > 0.50))
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: blue,
                        width: 3,
                      )),
                      child: InkWell(
                        onTap: () {
                          route(re["detectedClass"]);
                        },
                        child: Text(
                          "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            background: Paint()..color = blue,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  : Container()),
        );
      } 
      else if (detectedClass == "WHIMBREL") {
        return Container(
          child: Positioned(
              left: re["rect"]["x"] * factorX - 50,
              top: (re["rect"]["y"] * factorY) + 100,
              width: re["rect"]["w"] * factorX,
              height: re["rect"]["h"] * factorY,
              child: ((re["confidenceInClass"] > 0.50))
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: blue,
                        width: 3,
                      )),
                      child: InkWell(
                        onTap: () {
                          route(re["detectedClass"]);
                        },
                        child: Text(
                          "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            background: Paint()..color = blue,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  : Container()),
        );
      } 
      
      else {
        return Container(
          child: Positioned(
              left: re["rect"]["x"] * factorX,
              top: (re["rect"]["y"] * factorY) + 100,
              width: re["rect"]["w"] * factorX,
              height: re["rect"]["h"] * factorY,
              child: ((re["confidenceInClass"] > 0.50))
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: blue,
                        width: 3,
                      )),
                      child: InkWell(
                        onTap: () {
                          route(re["detectedClass"]);
                        },
                        child: Text(
                          "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            background: Paint()..color = blue,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  : Container()),
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      // using ternary operator
      child: _image == null
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Please Select an Image"),
                ],
              ),
            )
          : _image != null // if not null then
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.file(_image),
                  SizedBox(height: 50.0),
                ])
              : Container(),
    ));

    stackChildren.addAll(renderBoxes(size));
    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Bird Image Detector"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Fltbtn1",
            child: Icon(Icons.photo),
            onPressed: getImageFromGallery,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: stackChildren,
        ),
      ),
    );
  }

  // gets image from camera and runs detectObject
  /*
  Future getImageFromCamera() async {
  
// Here you can write your code

      setState(() {
        for (XFile i in pickedFile) {
          _image = File(i.path);
          print("55555555555555555555555555555555555555555555555555555555555555555555555555555555 "+i.path);
          detectObject(_image);
          sleep(Duration(seconds:1));
        }
      });
   
  }*/

  // gets image from gallery and runs detectObject
  Future getImageFromGallery() async {
    /*
    var f = ["assets/alex.jpg","assets/canary.jpg","assets/hoopoes.jpg","assets/pigeon.jpg","assets/whim.jpg"];
 
    setState(() {
      for (var i in f){
      
      _image = File(i);

      detectObject(_image);




    }
      
    });
    */
   /*
    XFile img = await picker.pickImage(source: ImageSource.gallery);

    pickedFile.add(img);
*/
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image Selected");
      }
    });
    detectObject(_image);
    
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
