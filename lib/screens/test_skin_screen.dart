import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TestSkinScreen extends StatefulWidget {
  TestSkinScreen({Key key}) : super(key: key);
  static const route = "/testSkin";

  @override
  _TestSkinScreenState createState() => _TestSkinScreenState();
}

class _TestSkinScreenState extends State<TestSkinScreen> {
  File _image;
  final picker = ImagePicker();
  String prediction = '';
  Color stateColor = Colors.red;
  DateTime _datetime = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  bool viewVisible = false;
  bool iconVisible = false;

  @override
  void dispose() {
    // TODO: implement dispose
    EasyLoading.dismiss();
    super.dispose();
  }

  void showWidget() {
    setState(() {
      viewVisible ? viewVisible = false : viewVisible = true;
    });
  }

  Future getImageWithCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Future<void> sendImageToServer(File imageFile) async {
  //   var stream = new http.ByteStream(imageFile.openRead());
  //   stream.cast();
  //   var length = await imageFile.length();
  //   print(length);

  //   //this ip is my network's IPv4 ( I connected both my laptop and mobile
  //   //to this WiFi while establishing the connection)

  //   var uri = Uri.parse('http://10.0.2.2:5000/prediction');
  //   var request = new http.MultipartRequest("POST", uri);
  //   var multipartFile = new http.MultipartFile('file', stream, length,
  //       filename: basename(imageFile.path));

  //   request.files.add(multipartFile);
  //   var response = await request.send();
  //   print(response.statusCode);
  //   print(response.statusCode);
  //   var result = await response.stream.bytesToString();

  //   final Map<String, dynamic> responseJson =
  //       json.decode(result) as Map<String, dynamic>;
  //   print(responseJson.toString());

  //   var pre = responseJson["prediction"];
  //   print(pre);

  //   setState(() {
  //     prediction = pre;
  //   });
  // }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Future<void> sendImageToServer(File imageFile, BuildContext context) async {
    print(imageFile.toString());
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    var uri = Uri.parse('http://192.168.43.16:5000/');
    var data;
    EasyLoading.show(status: 'testing...');
    final response = await http.post(
      uri,
      body: jsonEncode(
        {
          'image': base64Image,
        },
      ),
      headers: {
        'Content-Type': "application/json",
        'connection': 'keep-alive',
      },
    );
    print('StatusCode : ${response.statusCode}');
    print('Return Data : ${response.body}');
    data = jsonDecode(response.body);
    setState(() {
      prediction = data['result'];
    });
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      // String imgString = base64String(imageFile.readAsBytesSync());
      // var historyData = Provider.of<HistoryProvider>(context, listen: false);
      // final userData = Provider.of<UserProvider>(context, listen: false);
      // historyData.addHistory(History(
      //   user_id: userData.userInfo.user_id,
      //   date: DateFormat("yyyy-MM-dd").format(_datetime),
      //   picture: imgString,
      //   result: prediction,
      // ));

      setState(() {
        iconVisible = true;
      });
      var imageName = imageFile
          .toString()
          .split('/')[imageFile.toString().split('/').length - 1];
      final ref = FirebaseStorage.instance
          .ref()
          .child("HistoryImages")
          .child(user.uid)
          .child(imageName);

      await ref.putFile(_image);

      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('userHistory')
          .doc(imageName)
          .set({
        'image_url': url,
        'result': prediction,
        'test_date': DateFormat("yyyy-MM-dd").format(_datetime),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3.8,
            decoration: BoxDecoration(
              color: HexColor("#1b3260"),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Test your Skin',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Text(
                          'choose the way you want to upload your skin picture',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  child: ElevatedButton(
                    onPressed: getImageWithCamera,
                    child: FittedBox(
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(12),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(HexColor("#1b3260")),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  child: ElevatedButton(
                    onPressed: getImageFromGallery,
                    child: FittedBox(
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(12),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        HexColor('#a99e71'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _image == null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                )
              : SizedBox(
                  height: 30,
                ),
          _image == null
              ? Center(
                  child: Text(
                    "No picture selected!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Result : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    prediction,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: prediction.contains('Malignant')
                          ? stateColor = Colors.red
                          : stateColor = Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * .2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_image == null) {
                        return;
                      } else {
                        sendImageToServer(_image, context);
                      }
                    },
                    child: FittedBox(
                      child: Text(
                        'Test',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(12),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(HexColor("#1b3260")),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: iconVisible,
                    child: IconButton(
                      onPressed: showWidget,
                      icon: Icon(
                        Icons.info,
                        size: 40,
                        color: HexColor('#a99e71'),
                      ),
                    ))
              ]),
            ],
          ),
          Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: viewVisible,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0),
                child: Card(
                  color: HexColor('#a99e71'),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    height: 900,
                    width: 70,
                    margin: EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '•	skin cancer',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            '''the abnormal growth of skin cells — most often develops on skin exposed to the sun. But this common form of cancer can also occur on areas of your skin not ordinarily exposed to sunlight.''',
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Melanoma signs and symptoms',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            '''A large brownish spot with darker speckles

•	A mole that changes in color, size or feel or that bleeds

•	A small lesion with an irregular border and portions that appear red, pink, white, blue or blue-black

•	A painful lesion that itches or burns

•	Dark lesions on your palms, soles, fingertips or toes, or on mucous membranes lining your mouth, nose, vagina or anus

''',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'treatment ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            '''Freezing. 
•	Excisional surgery. 
•	Mohs surgery. 
•	Curettage and electrodesiccation or cryotherapy
•	Radiation therapy. 
•	Chemotherapy. 
•	Photodynamic therapy. 
•	Biological therapy.
''',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Prevention ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            '''•	Avoid the sun during the middle of the day. 
•	Wear sunscreen year-round. 
•	Wear protective clothing. 
•	Avoid tanning beds. 
•	Be aware of sun-sensitizing medications.
•	Check your skin regularly and report changes to your doctor.
''',
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
