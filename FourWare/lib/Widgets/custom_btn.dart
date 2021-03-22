import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlinebtn;
  final bool isloading;

  const CustomButton(
      {Key key, this.text, this.onPressed, this.outlinebtn, this.isloading});

  @override
  Widget build(BuildContext context) {
    bool _outlinebtn = outlinebtn ?? false;
    bool _isloading = isloading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 65.0,
        decoration: BoxDecoration(
          color: _outlinebtn ? Colors.transparent : Colors.black,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        child: Stack(
          children: [
            Visibility(
              visible: _isloading ? false : true,
              child: Center(
                child: Text(
                  text ?? "text",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: _outlinebtn ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isloading,
              child: Center(
                child: SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
