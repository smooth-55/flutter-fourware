import 'package:FourWare/Screens/vehicles_card.dart';
import 'package:FourWare/Screens/vehicle_page.dart';
import 'package:FourWare/Widgets/custom_input.dart';
import 'package:FourWare/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final CollectionReference _vehiclesRef =
      FirebaseFirestore.instance.collection("Vehicles");
  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
              child: Container(
                child: Text(
                  "Search Results",
                  style: Constants.regularDarkText,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: _vehiclesRef.orderBy('searchString').startAt(
                  ["$_searchString"]).endAt(["$_searchString\uf8ff"]).get(),
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
                      top: 130.0,
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
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInput(
              hintText: "Search here...",
              onSubmitted: (value) {
                setState(() {
                  _searchString = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
