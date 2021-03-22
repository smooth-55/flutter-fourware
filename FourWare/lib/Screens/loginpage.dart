import 'package:FourWare/Screens/registerpage.dart';
import 'package:FourWare/Widgets/custom_btn.dart';
import 'package:FourWare/Widgets/custom_input.dart';
import 'package:FourWare/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Container(
            child: Text(error),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close Dialog"),
            )
          ],
        );
      },
    );
  }

  //create a new user account
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _loginEmail,
        password: _loginPassword,
      );
      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e;
    }
  }

  void _submitForm() async {
    //set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    //run the create account method
    String _loginFeedback = await _loginAccount();

    //if the string is not null, we got error while login
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      //set the form to regular state;
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  //default form loading state
  bool _loginFormLoading = false;

  //form input field values
  String _loginEmail = "";
  String _loginPassword = "";

  //focus node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 25.0,
                ),
                child: Text(
                  "WELCOME!!!\n Login to your  Account",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Enter Your Email...",
                    onChanged: (value) {
                      _loginEmail = value;
                    },
                    onSubmitted: (value) {
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Enter Your Password...",
                    onChanged: (value) {
                      _loginPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                  ),
                  CustomButton(
                    text: "LOGIN",
                    onPressed: () {
                      _submitForm();
                    },
                    isloading: _loginFormLoading,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: CustomButton(
                  text: "Create New Account",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                  outlinebtn: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
