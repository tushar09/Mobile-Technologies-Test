import 'dart:io';

import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  getImeiNumber() {}

  @override
  State<StatefulWidget> createState() {
    return App();
  }
}

class App extends State<MyApp> {
  TextEditingController imeCtrl = TextEditingController(text: "");
  TextEditingController firstNameCtrl = TextEditingController(text: "");
  TextEditingController lastNameCtrl = TextEditingController(text: "");
  TextEditingController dateOfBirthCtrl = TextEditingController(text: "");
  TextEditingController passportCtrl = TextEditingController(text: "");
  TextEditingController emailCtrl = TextEditingController(text: "");

  String imeiNumber = "";
  bool is18Plus = false;
  ImagePicker picker = ImagePicker();
  late File imageFile = File("");

  final formGlobalKey = GlobalKey < FormState > ();

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
          title: const Text('Welcome to Flutter'),
        ),
        body: Form(
          key: formGlobalKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                              color: Colors.red,
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
      Permission.locationWhenInUse,
    ].request();

    print(statuses[Permission.locationWhenInUse].toString() + "hhjmnb");
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
      Permission.locationWhenInUse,
    ].request();
    print(statuses[Permission.locationWhenInUse].toString() + "vxb");
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1990, 8),
        initialDate: DateTime(1990, 9),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      print(DateTime.now().millisecondsSinceEpoch);
      setState(() {
        is18Plus = DateTime.now().millisecondsSinceEpoch - picked.millisecondsSinceEpoch > 568036800000;
        dateOfBirthCtrl.text = DateFormat('dd/MM/yyyy').format(selectedDate).toString();
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
    });
  }
}
