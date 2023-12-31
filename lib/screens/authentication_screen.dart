import 'dart:io';
import 'dart:math';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firebase = FirebaseAuth.instance;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthenticationState();
  }
}

class _AuthenticationState extends State<AuthenticationScreen> {
  var _isLogin = true;

  var form = GlobalKey<FormState>();
  var _enteredEmailAddress = '';
  var _enteredPassword = '';
  File? _selectedImage;
  bool _isAuthenticating = false;

  void _onImagePicked(File pickedImage) {
    _selectedImage = pickedImage;
  }

  void _submit() async {
    bool isValid = form.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }

    form.currentState!.save();

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmailAddress, password: _enteredPassword);
      } else {
        setState(() {
          _isAuthenticating = true;
        });
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmailAddress, password: _enteredPassword);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          "user_name": "..to be done",
          "email": _enteredEmailAddress,
          "image_url": imageUrl
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isAuthenticating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Authentication Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 20),
                width: 200,
                child: Image.asset("assets/images/chat.png"),
              ),
              Card(
                margin: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: form,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_isLogin)
                                UserImagePicker(
                                  onImagePicked: _onImagePicked,
                                ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.trim().contains("@")) {
                                    return "Please enter valid email address";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmailAddress = value!;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Password",
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.trim().length < 6) {
                                    return "Please enter valid password";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (_isAuthenticating)
                                const CircularProgressIndicator(),
                              if (!_isAuthenticating)
                                ElevatedButton(
                                    onPressed: () {
                                      _submit();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer),
                                    child: Text(_isLogin ? 'Login' : 'Signup')),
                              const SizedBox(
                                height: 5,
                              ),
                              if (!_isAuthenticating)
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Text(_isLogin
                                        ? 'Create an account'
                                        : 'I already have an account'))
                            ],
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
