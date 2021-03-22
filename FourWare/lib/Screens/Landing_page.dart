import 'package:FourWare/Screens/homepage.dart';
import 'package:FourWare/Screens/loginpage.dart';
import 'package:FourWare/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //if snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        //connection initialized - firebase app is running
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamsnapshot) {
              //if stream snapshot has error
              if (streamsnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamsnapshot.error}"),
                  ),
                );
              }

              //connection state active- Do the user login check inside the
              //if statement
              if (streamsnapshot.connectionState == ConnectionState.active) {
                //Get the user
                User _user = streamsnapshot.data;

                //if user is null, user is not logged in
                if (_user == null) {
                  //user not logind in, send to login
                  return Loginpage();
                } else {
                  //user logged in, sent to homepage
                  return Homepage();
                }
              }

              //checking the auth state - loading
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }

        //connecting to firebase - loading
        return Scaffold(
          body: Center(
            child: Text(
              "Initialization App...",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
