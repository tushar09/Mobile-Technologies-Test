import 'dart:io';

import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_technologies/databse_connection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return App();
  }
}

class App extends State<MyApp> {
  TextEditingController imeCtrl = TextEditingController(text: "");
  TextEditingController firstNameCtrl = TextEditingController(text: "Tushar");
  TextEditingController lastNameCtrl = TextEditingController(text: "Monirul");
  TextEditingController dateOfBirthCtrl = TextEditingController(text: "01/01/1995");
  TextEditingController passportCtrl = TextEditingController(text: "1234");
  TextEditingController emailCtrl = TextEditingController(text: "wtushar09@gmail.com");

  String imeiNumber = "";
  bool is18Plus = false;
  ImagePicker picker = ImagePicker();
  late File imageFile = File("");
  final formGlobalKey = GlobalKey < FormState > ();

  String lat = "";
  String lng = "";

  static Database? db;

  @override
  void initState() {
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mobile Technologies Test'),
        ),
        body: Form(
          key: formGlobalKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (imei){
                      if(imei == null || imei.trim().isEmpty){
                        return "Please enter your IMEI number";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: imeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'IMEI Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (fn){
                      if(fn == null || fn.trim().isEmpty){
                        return "Please enter your first name";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: firstNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (ln){
                      if(ln == null || ln.trim().isEmpty){
                        return "Please enter your last name";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: lastNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (dob){
                      if(dob == null || dob.trim().isEmpty){
                        return "Please select your date of birth";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    enableInteractiveSelection: false,
                    readOnly: true,
                    controller: dateOfBirthCtrl,
                    onTap: () {
                      _selectDate(context);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Date of birth',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Visibility(
                    visible: is18Plus,
                    child: SizedBox(height: 20)),
                  Visibility(
                    visible: is18Plus,
                    child: TextFormField(
                      validator: (pp){
                        if((pp == null || pp.trim().isEmpty) && is18Plus){
                          return "Please enter your passport number";
                        }
                        return null;
                      },
                    textInputAction: TextInputAction.next,
                      controller: passportCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Passport',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (pp){
                      if((pp != null && pp.isNotEmpty)){
                        //bool emailValid = ;
                        if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(pp)){
                          return "Invalid email";
                        }
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: (){
                      takeImage();
                    },
                    child: Container(
                        alignment: imageFile.path == "" ? Alignment.centerLeft : Alignment.center,
                        width: double.infinity,
                        height: imageFile.path == "" ? 50 : 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.file(imageFile, errorBuilder:
                              (BuildContext context, Object exception, StackTrace? stackTrace) {
                            // Appropriate logging or analytics, e.g.
                            // myAnalytics.recordError(
                            //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                            //   exception,
                            //   stackTrace,
                            // );
                            return const Text("Please take image");
                          }),
                        )
                        //child: FadeInImage..assetNetwork(placeholder: 'assets/use.png', image: imageFile.path)
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                    ),
                    onPressed: () {
                      if (formGlobalKey.currentState!.validate()) {
                        //print("adf");
                        storeUser();
                      }

                    },
                    child: Text('Submit'),
                  )
                  // RaisedButton(onPressed: () {
                  //   print("sDFdf");
                  //   askPermission();
                  // })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.locationWhenInUse,
      Permission.camera,
    ].request();

    print(statuses[Permission.locationWhenInUse].toString() + "hhjmnb");

    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude.toString();
      lng = position.longitude.toString();
      print(position.latitude.toString() + " " + position.longitude.toString());
    }

    try {
      String imei = await DeviceInformation.deviceIMEINumber;
      setState(() {
        imeCtrl.text = imei;
      });
    } on PlatformException catch (e) {
      print("App " + '${e.message}');
    }
  }

  Future<void> askPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.locationWhenInUse,
      Permission.camera,
    ].request();
    print(statuses[Permission.locationWhenInUse].toString() + "vxb");
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1990, 8),
        initialDate: DateTime(1990, 9),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      print(DateTime.now().millisecondsSinceEpoch);
      setState(() {
        is18Plus = DateTime.now().millisecondsSinceEpoch - picked.millisecondsSinceEpoch > 568036800000;
        dateOfBirthCtrl.text = DateFormat('dd/MM/yyyy').format(picked).toString();
        print(is18Plus);
      });
    }
  }

  void validateData() {

  }

  Future<void> takeImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(image!.path);
      print(imageFile.path);
    });
  }

  void storeUser() async{
    if(lat.isEmpty){
      if (await Permission.locationWhenInUse.isGranted) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        lat = position.latitude.toString();
        lng = position.longitude.toString();
      }else if (await Permission.location.isPermanentlyDenied) {
        Fluttertoast.showToast(
            msg: "PLease allow location permission from setting",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        Map<Permission, PermissionStatus> statuses = await [
          Permission.locationWhenInUse,
        ].request();
      }
      return;
    }else{

    }

    if(imageFile.path.isEmpty){
      Fluttertoast.showToast(
          msg: "Please take image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }
    Database db = await DatabaseConnection().setDatabase();
    final Map<String, String> user = {
      "imei": imeCtrl.text,
      "firstName": firstNameCtrl.text,
      "lastName": lastNameCtrl.text,
      "dob": dateOfBirthCtrl.text,
      "passport": passportCtrl.text,
      "email": emailCtrl.text,
      "picture": imageFile.path,
      "lat": lat,
      "lng": lng,
    };
    try{
      await db.insert("user", user);
      Fluttertoast.showToast(
          msg: "User created successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0
      );
      formGlobalKey.currentState!.reset();
      imeCtrl.text = "";
      firstNameCtrl.text = "";
      lastNameCtrl.text = "";
      dateOfBirthCtrl.text = "";
      passportCtrl.text = "";
      emailCtrl.text = "";
      setState(() {
        imageFile = File("");
      });
    }on DatabaseException{
      Fluttertoast.showToast(
          msg: "Duplicate imei number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print("e.toString()");
    }

  }
}
