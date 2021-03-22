import 'package:flutter/material.dart';

class Driver extends StatefulWidget {
  final List vehicleDriver;
  final Function(String) onSelected;

  const Driver({
    this.vehicleDriver,
    this.onSelected,
  });

  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 19.5,
      ),
      child: Row(
        children: [
          for (var i = 0; i < widget.vehicleDriver.length; i++)
            GestureDetector(
              onTap: () {
                widget.onSelected("${widget.vehicleDriver[i]}");
                setState(() {
                  _selected = i;
                });
              },
              child: Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: _selected == i
                      ? Theme.of(context).accentColor
                      : Color(0xFFDCDCDC),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Text(
                  "${widget.vehicleDriver[i]}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selected == i ? Colors.white : Colors.black,
                    fontSize: 13.0,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
