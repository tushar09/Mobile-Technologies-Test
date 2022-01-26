import 'dart:io';

import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: imeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'IMEI Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: firstNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'First name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: lastNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Last name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
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
                    controller: passportCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Passport',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(onPressed: () {
                  print("sDFdf");
                  askPermission();
                })
              ],
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
      });
    }
  }
}
