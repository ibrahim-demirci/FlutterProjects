import 'package:flutter/material.dart';

class MyRaiseButton extends StatelessWidget {

  final Widget child;
  final Color color;
  final VoidCallback onPressed;

  const MyRaiseButton({Key key, @required this.color, @required this.onPressed,@required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(

        // Tiklandiginda degisecek renk
        disabledColor: color.withOpacity(0.8),
        color: color,
        onPressed: onPressed,
        child: child,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
