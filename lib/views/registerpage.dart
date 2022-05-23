import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mytutor/views/loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/avatar.png';
  bool _isChecked = false;
  var _image;

  final TextEditingController _trnameController = TextEditingController();
  final TextEditingController _tremailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController _trpassController = TextEditingController();
  final TextEditingController _trpass2Controller = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth / 1.1;
    }
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(0, 48, 0, 0),
      child: Scaffold(
          appBar: AppBar(
              title: const Text('Registration'),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  })),
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                  width: ctrwidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => {_takePictureDialog()},
                          child: Center(
                            child: _image == null
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 140,
                                  )
                                : CircleAvatar(
                                    backgroundImage: FileImage(_image),
                                    radius: 65.0,
                                  ),
                          ),
                        ),
                        TextButton(
                          onPressed: _takePictureDialog,
                          child: const Text(
                            "Upload your picture",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _trnameController,
                          decoration: InputDecoration(
                              labelText: "Name",
                              prefixIcon:
                                            const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "name must be longer than 3"
                              : null,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _tremailController,
                          decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid email';
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);

                            if (!emailValid) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                                  TextFormField(
                                    controller: phoneNoController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        prefixIcon:
                                            const Icon(Icons.phone_android),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0))),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter valid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: addressController,
                                    minLines: 6,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                        labelText: 'Address',
                                        alignLabelWithHint: true,
                                        prefixIcon: const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 100),
                                            child: Icon(Icons.house_outlined)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0))),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _trpassController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _trpass2Controller,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Re-enter Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter your password correctly';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                }),
                            Flexible(
                                child: GestureDetector(
                                    onTap: null,
                                    child: const Text(
                                        'Agree with terms & conditions'))),
                          ],
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: screenWidth,
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () {
                                _insertDialog();
                                /*if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                }*/
                              },
                              child: const Text("REGISTER",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  )),
            ),
          )),
    );
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select from"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        _gallerypicker(),
                      },
                  icon: const Icon(Icons.browse_gallery),
                  label: const Text("Gallery")),
              TextButton.icon(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        _cameraPicker(),
                      },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera")),
            ],
          ),
        );
      },
    );
  }

  _gallerypicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _insertDialog() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register a new account?",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _insertNewTutor();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  
  void _insertNewTutor() {
    String name = _trnameController.text;
    String email = _tremailController.text;
    String phoneNo = phoneNoController.text;
    String address = addressController.text;
    String pass = _trpassController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/new_tutor.php"),
        body: {
          "name": name,
          "email": email,
          "phoneNo": phoneNo,
          "address": address,
          "pass": pass,
          "image": base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => const LoginScreen(
                      )));
      } else {
        Fluttertoast.showToast(
            msg: data['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}