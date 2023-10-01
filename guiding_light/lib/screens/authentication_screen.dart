// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:guiding_light/customs_common/custom_button.dart';
import 'package:guiding_light/services/authentication_services.dart';

class AuthenticationScreen extends StatefulWidget {
  static const String routeName = '/authentication-screen';
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
  //final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool checkBoxValue = false;
  final _signUpKey = GlobalKey<FormState>();
  final _signInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final AuthenticationService authenticationService = AuthenticationService();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
  }

  void signUpUser() {
    authenticationService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text);
  }

  void signInUser() {
    authenticationService.signInUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldMessengerKey,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 800,
          decoration:
              const BoxDecoration(color: Color.fromRGBO(3, 169, 244, 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              DefaultTabController(
                length: 2,
                child: SingleChildScrollView(
                  child: Container(
                    height: 600,
                    width: 325,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 254, 253, 253),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TabBar(
                                isScrollable: true,
                                indicator: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(30)),
                                tabs: const [
                                  Tab(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors
                                              .black), // Set the text color here
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                          color: Colors
                                              .black), // Set the text color here
                                    ),
                                  ),
                                ])),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 500,
                          width: 300,
                          child: TabBarView(children: [
                            Form(
                              key: _signInKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      fillColor: Color.fromARGB(255, 7, 7, 7),
                                      hintText: 'username',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      fillColor: Color.fromARGB(255, 7, 7, 7),
                                      hintText: 'password',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomButton(
                                    onTap: () {
                                      if (_signInKey.currentState!.validate()) {
                                        signInUser();
                                      }
                                    },
                                    text: 'Login',
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 400,
                              width: 250,
                              child: Column(
                                children: [
                                  Form(
                                    key: _signUpKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                            fillColor:
                                                Color.fromARGB(255, 7, 7, 7),
                                            hintText: 'Name',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                            fillColor:
                                                Color.fromARGB(255, 7, 7, 7),
                                            hintText: 'email address',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: _phoneNumberController,
                                          decoration: const InputDecoration(
                                            fillColor:
                                                Color.fromARGB(255, 7, 7, 7),
                                            hintText: 'Phone number',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: _passwordController,
                                          decoration: const InputDecoration(
                                            fillColor:
                                                Color.fromARGB(255, 7, 7, 7),
                                            hintText: 'password',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller:
                                              _confirmPasswordController,
                                          decoration: const InputDecoration(
                                            fillColor:
                                                Color.fromARGB(255, 7, 7, 7),
                                            hintText: 'confirm password',
                                          ),
                                          validator: (value) {
                                            if (_confirmPasswordController
                                                    .text !=
                                                _passwordController.text) {
                                              return "Password did not match";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                            child: Row(
                                          children: [
                                            Checkbox(
                                              value: checkBoxValue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  checkBoxValue = value!;
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Accept Terms and Conditions',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        )),
                                        CustomButton(
                                          onTap: () {
                                            if (_signUpKey.currentState!
                                                .validate()) {
                                              signUpUser();
                                            }
                                          },
                                          text: 'register',
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
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
