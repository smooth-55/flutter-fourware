import 'package:flutter/material.dart';

class VehicleDays extends StatefulWidget {
  final List vehicleDays;
  final Function(String) onSelected;

  const VehicleDays({
    this.vehicleDays,
    this.onSelected,
  });

  @override
  _VehicleDaysState createState() => _VehicleDaysState();
}

class _VehicleDaysState extends State<VehicleDays> {
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 19.5,
      ),
      child: Row(
        children: [
          for (var i = 0; i < widget.vehicleDays.length; i++)
            GestureDetector(
              onTap: () {
                widget.onSelected("${widget.vehicleDays[i]}");
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
                  "${widget.vehicleDays[i]}",
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
