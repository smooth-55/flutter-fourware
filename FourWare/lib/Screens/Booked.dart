import 'package:FourWare/Screens/vehicle_page.dart';
import 'package:FourWare/Widgets/action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookedPage extends StatefulWidget {
  @override
  _BookedPageState createState() => _BookedPageState();
}

class _BookedPageState extends State<BookedPage> {
  final CollectionReference _vehiclesRef =
      FirebaseFirestore.instance.collection("Vehicles");

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  User _user = FirebaseAuth.instance.currentUser;

  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _usersRef.doc(_user.uid).collection("Booked").get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              //collection data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                // display the data inside a lost view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 110.0,
                    bottom: 13.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VehiclePage(vehicleID: document.id),
                            ));
                      },
                      child: FutureBuilder(
                        future: _vehiclesRef.doc(document.id).get(),
                        builder: (context, vehicleSnap) {
                          if (vehicleSnap.hasError) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "${vehicleSnap.error}",
                                ),
                              ),
                            );
                          }
                          if (vehicleSnap.connectionState ==
                              ConnectionState.done) {
                            Map _vehicleMap = vehicleSnap.data.data();
                            return Dismissible(
                              key: ObjectKey(document.data().keys),
                              onDismissed: (direction) {
                                document.data().remove(index);
                              },
                              direction: DismissDirection.startToEnd,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          "${_vehicleMap['Image']}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_vehicleMap['Name']}",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              "\$${_vehicleMap['Price']} per day",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Booked Days - ${document.data()['HiringDays']}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "Driver included - ${document.data()['Driver']}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              }

              //loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          ActionBar(
            backArrow: true,
            title: "My Bookings",
            hasBackground: false,
            hasCart: false,
          )
        ],
      ),
    );
  }
}
