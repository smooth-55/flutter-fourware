import 'package:FourWare/Screens/location_input.dart';
import 'package:FourWare/Screens/location_search.dart';
import 'package:FourWare/Screens/place._service.dart';
import 'package:FourWare/Widgets/action_bar.dart';
import 'package:FourWare/Widgets/booked_days.dart';
import 'package:FourWare/Widgets/driver.dart';
import 'package:FourWare/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class VehiclePage extends StatefulWidget {
  final String vehicleID;

  const VehiclePage({
    this.vehicleID,
  });

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final _destinationController = TextEditingController();

  final CollectionReference _vehiclesRef =
      FirebaseFirestore.instance.collection("Vehicles");

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  User _user = FirebaseAuth.instance.currentUser;

  String _selectedVehicleDays = "0";

  String _selectedDriver = "0";

  Future _addToSaved() {
    return _usersRef
        .doc(_user.uid)
        .collection("Saved")
        .doc(widget.vehicleID)
        .set({
      "HiringDays": _selectedVehicleDays,
      "Driver": _selectedDriver,
    });
  }

  Future _addToBooked() {
    return _usersRef
        .doc(_user.uid)
        .collection("Booked")
        .doc(widget.vehicleID)
        .set({
      "HiringDays": _selectedVehicleDays,
      "Driver": _selectedDriver,
    });
  }

  final SnackBar _snackBar = SnackBar(
    content: Text("Booked Successfully"),
  );

  final SnackBar _snackBar2 = SnackBar(
    content: Text("Saved"),
  );

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  _search() async {
    final sessionToken = Uuid().v4();
    final Suggestion result = await showSearch(
      context: context,
      delegate: LocationSearch(sessionToken),
    );
    if (result != null) {
      setState(() {
        _destinationController.text = result.description;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _vehiclesRef.doc(widget.vehicleID).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> documentData = snapshot.data.data();

                List vehicleDays = documentData['HiringDays'];

                List vehicleDriver = documentData['Driver'];

                //set an initial hiring days
                _selectedVehicleDays = vehicleDays[0];

                _selectedDriver = vehicleDriver[0];

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    Container(
                      height: 250,
                      child: Image.network(
                        "${documentData['Image']}",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        bottom: 2.0,
                        left: 24.0,
                        right: 24.0,
                      ),
                      child: Text(
                        "${documentData['Name']}",
                        style: Constants.regularHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "\$${documentData['Price']} per day",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "${documentData['Description']}",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "For how many days?",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    VehicleDays(
                      vehicleDays: vehicleDays,
                      onSelected: (days) {
                        _selectedVehicleDays = days;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Need Driver?",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    Driver(
                      vehicleDriver: vehicleDriver,
                      onSelected: (driver) {
                        _selectedDriver = driver;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                      ),
                      child: Text(
                        "Enter Location",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PreferredSize(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            AddressInput(
                              controller: _destinationController,
                              iconData: Icons.place_sharp,
                              hintText: "Pick-Up Location",
                              onTap: _search,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                AddressInput(
                                  controller: _destinationController,
                                  iconData: Icons.place_sharp,
                                  hintText: "Drop-Off Location",
                                  onTap: _search,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      preferredSize: Size.fromHeight(100),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_snackBar2);
                            },
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  "assets/images/saved.png",
                                ),
                                height: 22.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _addToBooked();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                height: 65.0,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Book this Vehicle",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
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
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
