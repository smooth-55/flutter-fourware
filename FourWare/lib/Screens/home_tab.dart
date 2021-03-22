import 'package:FourWare/Screens/vehicles_card.dart';
import 'package:FourWare/Screens/vehicle_page.dart';
import 'package:FourWare/Widgets/action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _vehiclesRef =
      FirebaseFirestore.instance.collection("Vehicles");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _vehiclesRef.get(),
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
                    return VehicleCard(
                      imageUrl: document.data()['Image'],
                      name: document.data()['Name'],
                      price: "\$${document.data()['Price']} per day",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehiclePage(
                              vehicleID: document.id,
                            ),
                          ),
                        );
                      },
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
            title: "Home",
            backArrow: false,
          ),
        ],
      ),
    );
  }
}
