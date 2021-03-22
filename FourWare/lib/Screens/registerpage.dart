import 'package:FourWare/Widgets/custom_btn.dart';
import 'package:FourWare/Widgets/custom_input.dart';
import 'package:FourWare/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //build an alert dialog to display some errors
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
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _regEmail,
        password: _regPassword,
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
      _registerFormLoading = true;
    });

    //run the create account method
    String _createAccountFeedback = await _createAccount();

    //if the string is not null, we got error while create account
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      //set the form to regular state;
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      //the string was null, user is logged in.
      Navigator.pop(context);
    }
  }

  //default form loading state
  bool _registerFormLoading = false;

  //form input field values
  String _regEmail = "";
  String _regPassword = "";

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
                  "Create A New Account",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Enter Your Email...",
                    onChanged: (value) {
                      _regEmail = value;
                    },
                    onSubmitted: (value) {
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Enter Your Password...",
                    onChanged: (value) {
                      _regPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                  ),
                  CustomButton(
                    text: "CREATE",
                    onPressed: () {
                      _submitForm();
                    },
                    isloading: _registerFormLoading,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: CustomButton(
                  text: "Back to Login",
                  onPressed: () {
                    Navigator.pop(context);
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
