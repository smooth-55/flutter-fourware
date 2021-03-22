import 'package:FourWare/Screens/Booked.dart';
import 'package:FourWare/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActionBar extends StatefulWidget {
  final String title;
  final bool backArrow;
  final bool hasTitle;
  final bool hasBackground;
  final bool hasCart;

  ActionBar({
    this.title,
    this.backArrow,
    this.hasTitle,
    this.hasBackground,
    this.hasCart,
  });

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    bool _backArrow = widget.backArrow ?? false;
    bool _hasTitle = widget.hasTitle ?? true;
    bool _hasBackground = widget.hasBackground ?? true;
    bool _hasCart = widget.hasCart ?? true;

    return Container(
      decoration: BoxDecoration(
        gradient: _hasBackground
            ? LinearGradient(
                colors: [
                  Colors.red,
                  Colors.white.withOpacity(0),
                ],
                begin: Alignment(0, 0),
                end: Alignment(0, 1),
              )
            : null,
      ),
      padding: EdgeInsets.only(
        top: 56.0,
        bottom: 42.0,
        left: 24.0,
        right: 24.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_backArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage(
                    "assets/images/back_arrow.png",
                  ),
                  color: Colors.white,
                  width: 16.0,
                  height: 16.0,
                ),
              ),
            ),
          if (_hasTitle)
            Padding(
              padding: const EdgeInsets.only(
                right: 110.0,
              ),
              child: Text(
                widget.title ?? "Action bar",
                style: Constants.boldHeading,
              ),
            ),
          if (_hasCart)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookedPage(),
                  ),
                );
              },
              child: Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: StreamBuilder(
                    stream: _usersRef
                        .doc(_user.uid)
                        .collection("Booked")
                        .snapshots(),
                    builder: (context, snapshot) {
                      int _totalItems = 0;

                      if (snapshot.connectionState == ConnectionState.active) {
                        List _documents = snapshot.data.docs;
                        _totalItems = _documents.length;
                      }
                      return Text(
                        "$_totalItems" ?? '0',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    },
                  )),
            )
        ],
      ),
    );
  }
}
