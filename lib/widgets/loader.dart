import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SpinKitFadingGrid(
          color:   Color(0xFFFDAAAB),
          size: 120,
        ),
      ),
    );
  }
}
