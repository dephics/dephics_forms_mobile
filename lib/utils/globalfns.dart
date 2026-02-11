import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:survey_app/resources/dimensions.dart';

showToast({message, isGood}) {
  Fluttertoast.showToast(
    msg: message,
    fontSize: fsm,
    timeInSecForIosWeb: 1,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isGood ? Colors.green : Colors.red,
  );
}

showProgress(context) {
  return showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Please wait...",
    builder: (context) {
      return Center(
        child: SizedBox(
          height: kToolbarHeight * 2,
          width: MediaQuery.of(context).size.width * 0.7,
          child: const BuildLoadr(),
        ),
      );
    },
  );
}

class BuildLoadr extends StatelessWidget {
  const BuildLoadr({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: psm * 0.5),
            Text("Loading.."),
          ],
        ),
      ),
    );
  }
}
