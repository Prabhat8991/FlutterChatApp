import 'package:flutter/material.dart';

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

  void _submit() {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
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
