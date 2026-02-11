// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:survey_app/views/all_forms.dart';

// class Splash extends StatefulWidget {
//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   @override
//   void initState() {
//     initer();
//     super.initState();
//   }

//   initer() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    final String? token = prefs.getString('token');
//     await Future.delayed(const Duration(seconds: 4));
//     if (token != null) {
//       pushy(widgy: const AllForms());
//     } else {
//       pushy(widgy: const Login());
//     }
//   }

//   pushy({widgy}) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) {
//         return widgy;
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: TextButton(
//         onPressed: () {},
//         child: const Text("(c) DMI Tanzania"),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       body: Center(
//         child: Text(
//           "appname",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
