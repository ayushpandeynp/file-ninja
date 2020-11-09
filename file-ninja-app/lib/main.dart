import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import './colors.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'File Ninja',
      theme: ThemeData(
          primarySwatch: Colors.pink, primaryColor: colors["colorPrimary"]),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

String sessionId = "";
List<Map<String, dynamic>> files = [];

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    startSession();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.security,
                  color: Colors.white,
                ),
                onPressed: () {
                  // privacy policy on the web
                  launch("https://fileninja.tk/privacy-policy");
                }),
            Container(
              width: 5,
            )
          ],
          title: Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/ninjawhite.png', height: 22),
              Container(
                width: 15,
              ),
              Text("File Ninja")
            ],
          )),
        ),
        body: SingleChildScrollView(
            child: (sessionId != "")
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 10,
                        ),
                        // unique code display
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Text(sessionId,
                                  style: TextStyle(
                                      color: colors["darkText"],
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1)),
                              Container(
                                height: 5,
                              ),
                              Text(
                                  "Use this code to access your files\nat fileninja.tk",
                                  style: TextStyle(
                                    color: colors["darkText"],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),

                        // GAP
                        Container(
                          height: 30,
                        ),

                        // file upload widget
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                      children: <Widget>[
                                        SimpleDialogOption(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              selectImage(context, 'camera');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 5),
                                              child: Text("Open Camera"),
                                            )),
                                        SimpleDialogOption(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              selectImage(context, 'gallery');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 5),
                                              child: Text("Select Image"),
                                            )),
                                      ],
                                    ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.backup,
                                  color: colors["uploadIconColor"],
                                  size: 40,
                                ),
                                Container(height: 8),
                                Text("Select or Capture an Image",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: colors["fadeGrey"],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1, color: colors["borderColor"])),
                          ),
                        ),

                        // GAP
                        Container(
                          height: 30,
                        ),

                        (files.length > 0)
                            ? Column(
                                children: <Widget>[
                                  // selected files
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Selected Files",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text("Upload Status ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500]))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  ListView.separated(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 20),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: files.length,
                                      separatorBuilder: (context, index) {
                                        return Container(
                                          height: 8,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: colors["borderColor"]),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                color: Colors.grey[200],
                                                child: Image.file(
                                                  files[index]["file"],
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Image " +
                                                            (index + 1)
                                                                .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: colors[
                                                              "darkText"],
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Container(height: 5),
                                                      Text(
                                                        getMegaByte(files[index]
                                                                ["file"]) +
                                                            " MB",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                  ),
                                                ),
                                              ),
                                              (files[index]["uploaded"])
                                                  ? Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.green[800],
                                                      size: 24)
                                                  : CupertinoActivityIndicator(
                                                      animating: true,
                                                      radius: 10),
                                              Container(
                                                width: 30,
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  )

                // display ProgressIndicator
                : Container(
                    height: 200,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )))));
  }

  void startSession() async {
    if (sessionId == "") {
      try {
        http.Response res =
            await http.get("https://fileninja.tk/appdata/sessionManager.php");

        if (res.statusCode == 200 && res.body.toString() != "failure") {
          setState(() {
            sessionId = res.body.toString();
          });
        }
      } on Exception {
        print("An error occured.");
      }
    }
  }

  File file;
  final picker = ImagePicker();

  Future selectImage(BuildContext context, String type) async {
    file = null;
    try {
      var pickedfile = await picker.getImage(
          source:
              (type == "gallery") ? ImageSource.gallery : ImageSource.camera);

      if (pickedfile != null) {
        file = File(pickedfile.path);
        if (file != null) {
          setState(() {
            files.add({"file": file, "uploaded": false});
            uploadImage(file, files.length - 1);
          });
        }
      }
    } on PlatformException {
      print("An error occured.");
    }
  }

  String getMegaByte(File file) {
    String mb;
    mb = (file.lengthSync() / (pow(1024, 2))).toStringAsFixed(2);
    return mb;
  }

  void uploadImage(file, fileIndex) async {
    FormData data = new FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path,
          filename: p.basename(file.path)),
      "token_id": sessionId
    });

    try {
      Response res = await Dio()
          .post("https://fileninja.tk/appdata/uploadFile.php", data: data);

      if (res.statusCode == 200 && res.data != null) {
        if (res.data.toString() == "success") {
          setState(() {
            files[fileIndex]["uploaded"] = true;
          });
        }
      }
    } on Exception {
      print("An error occured.");
    }
  }
}
