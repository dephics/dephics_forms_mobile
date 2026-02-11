import 'package:flutter/cupertino.dart';
import 'package:survey_app/models/outlet_report_payload.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service that submits the outlet report.
/// Currently simulates a delay; plug the real HTTP request below.
class OutletReportService {
  OutletReportService();

  /// Submits the report. Replace the simulated delay with your HTTP call.
  /// Example with package:http:
  ///   dependencies: http: ^1.2.0
  ///   import 'package:http/http.dart' as http;
  ///   import 'package:survey_app/config/report_api_config.dart';
  Future<void> submitReport(OutletReportPayload payload) async {
    final body = payload.toMap();

    // ------------ SIMULATED REQUEST (remove block when plugging real HTTP) ------------
    await Future.delayed(const Duration(seconds: 2));
    // ignore: avoid_print
    print(
      'OutletReportService.submitReport simulated success. Payload keys: ${body.keys.toList()}',
    );
    return;
    // ------------ PLUG REAL HTTP HERE ------------
    // Uncomment and adjust after adding http to pubspec.yaml:
    //
    // import 'package:http/http.dart' as http;
    // import 'package:survey_app/config/report_api_config.dart';
    //
    // final url = Uri.parse(
    //   '${ReportApiConfig.baseUrl}${ReportApiConfig.submitPath(ReportApiConfig.projectId)}',
    // );
    // final response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(body),
    // );
    // if (response.statusCode != 200 && response.statusCode != 201) {
    //   throw Exception('Submit failed: ${response.statusCode} ${response.body}');
    // }
  }
}

const sharedHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

const respGood = "isGood";
const respBody = 'body';
const respError = "error";
const prodGenrl = "https://cornerstone.core.tz/promo/form-data";
// const debugGenrl = "http://192.168.100.16:1235/graphql";
const prodAuthrl = "https://cornerstone.core.tz/auth/graphql/auth";
// const debugAuthrl = "http://192.168.100.16:1235/graphql/auth";

class YeAuth {
  var yeauthrl = Uri.parse(prodAuthrl);
  Future shoot({variables, query}) async {
    try {
      //
      var response = await http.post(
        yeauthrl,
        headers: sharedHeaders,
        body: jsonEncode({'query': query, 'variables': variables}),
      );
      var body = jsonDecode(response.body);
      return {respGood: true, respBody: body};
    } catch (e) {
      return {
        respGood: false,
        respBody: {respError: "$e"},
      };
    }
  }
}

class YeGen {
  var yegenrl = Uri.parse(prodGenrl);
  Future shoot({variables, query}) async {
    try {
      var response = await http.post(
        yegenrl,
        headers: sharedHeaders,
        body: jsonEncode(variables),
        // body: jsonEncode({'query': query, 'variables': variables}),
      );
      debugPrint("Response 00: $response");
      var body = jsonDecode(response.body);
      debugPrint("Response 01: $body");
      return {respGood: true, respBody: body};
    } catch (e) {
      debugPrint("Response 02: $e");
      return {
        respGood: false,
        respBody: {respError: "$e"},
      };
    }
  }
}

// class ResService {
//   static Future downRes({String? fileUrl, Function(String)? fdbck}) async {
//     try {
//       // Get user selected directory
//       String? selDir = await FilePicker.platform.getDirectoryPath();
//       if (selDir == null) {
//         return;
//       }
//       // Create a reference to the file in Firebase Storage
//       final videoref = FirebaseStorage.instance.refFromURL(fileUrl!);
//       // Get the total size of the file
//       final metadata = await videoref.getMetadata();
//       final totalBytes = metadata.size ?? 0;
//       String? contentType = metadata.contentType;
//       String rndNum = (Random().nextInt(9000) + 1000).toString();
//       String cleanType = contentType!.split('/').last;
//       final filePath = '$selDir/$rndNum.$cleanType';
//       final videofile = File(filePath);
//       // Start the download
//       showToast(isGood: true, message: "Initiating Download Sequence");
//       // await thumbnailref.writeToFile(thumbnailfile);
//       final downloadTask = videoref.writeToFile(videofile);

//       // Listen to the download progress
//       downloadTask.snapshotEvents.listen((taskSnapshot) async {
//         switch (taskSnapshot.state) {
//           case TaskState.running:
//             final progress = taskSnapshot.bytesTransferred / totalBytes;
//             String percent = "${(progress * 100).truncate()} %";
//             fdbck!(percent);
//             break;
//           case TaskState.success:
//             fdbck!("Success");
//             break;
//           case TaskState.error:
//             fdbck!("Retry");
//             break;
//           default:
//             //
//             break;
//         }
//       });

//       // Wait for the download to complete
//       await downloadTask;
//       return;
//     } catch (e) {
//       showToast(isGood: false, message: "$e");
//       return;
//     }
//   }
// }
