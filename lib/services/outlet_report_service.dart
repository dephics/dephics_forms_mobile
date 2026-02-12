import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_app/models/outlet_report_payload.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:survey_app/utils/yekonga/ye_gvars.dart';

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

var sharedHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

const respGood = "isGood";
const respBody = 'body';
const respError = "error";
const prodPulGenrl = "https://cornerstone.core.tz/promo/graphql";
const prodPicGenrl = "https://cornerstone.core.tz/promo/upload-files"; // {files:[]}
const prodPosGenrl = "https://cornerstone.core.tz/promo/form-data";
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

  /*

{
files: 
}

  */
}

class YeGenV1 {
  var yegenrl = Uri.parse(prodPulGenrl);
  var genAuthRl = Uri.parse(prodAuthrl);
  shooterAuth({variables, query}) async {
    try {
      var response = await http.post(
        genAuthRl,
        headers: sharedHeaders,
        body: jsonEncode({'query': query, 'variables': variables}),
      );
      var body = jsonDecode(response.body);
      debugPrint("Look at body: $body $query");
      return {respGood: true, respBody: body};
    } catch (e) {
      return {
        respGood: false,
        respBody: {respError: "$e"},
      };
    }
  }

  shooter({variables, query}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var uAccessToken = prefs.getString(ygAccesstoken);
      var response = await http.post(
        yegenrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $uAccessToken",
        },
        body: jsonEncode({'query': query, 'variables': variables}),
      );
      debugPrint("Access: $uAccessToken");
      var body = jsonDecode(response.body);
      return {respGood: true, respBody: body};
    } catch (e) {
      return {
        respGood: false,
        respBody: {respError: "$e"},
      };
    }
  }

  Future spShoot({variables, query}) async {
    try {
      var response = await http.post(
        yegenrl,
        headers: sharedHeaders,
        body: jsonEncode(variables),
        // body: jsonEncode({'query': query, 'variables': variables}),
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

class YeGenV2 {
  var yegenrl = Uri.parse(prodPosGenrl);
  var genAuthRl = Uri.parse(prodAuthrl);
  var genPicRl = Uri.parse(prodPicGenrl);
  shooterAuth({variables, query}) async {
    try {
      var response = await http.post(
        genAuthRl,
        headers: sharedHeaders,
        body: jsonEncode({'query': query, 'variables': variables}),
      );
      var body = jsonDecode(response.body);
      debugPrint("Look at body: $body $query");
      return {respGood: true, respBody: body};
    } catch (e) {
      return {
        respGood: false,
        respBody: {respError: "$e"},
      };
    }
  }

  shooter({variables, query}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var uAccessToken = prefs.getString(ygAccesstoken);
      var response = await http.post(
        yegenrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $uAccessToken",
        },
        body: jsonEncode({'query': query, 'variables': variables}),
      );
      debugPrint("Look at kweru us: $query $variables");
      var body = jsonDecode(response.body);
      return {respGood: true, respBody: body};
    } catch (e) {
      debugPrint("Look at kweru us: $query $variables");
      return {
        respGood: false,
        respBody: {respError: "$e"},
      };
    }
  }

  Future spShoot({variables, query}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var uAccessToken = prefs.getString(ygAccesstoken);
      var response = await http.post(
        yegenrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $uAccessToken",
        },
        body: jsonEncode(variables),
        // body: jsonEncode({'query': query, 'variables': variables}),
      );

      var body = jsonDecode(response.body);
      debugPrint("Kookay: $variables");
      return {respGood: true, respBody: body};
    } catch (e) {
      debugPrint("Kooked: $variables");
      return {
        respGood: false,
        respBody: {respError: "$e"},
      };
    }
  }

  Future picShoot({variables, query}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var uAccessToken = prefs.getString(ygAccesstoken);
      var response = await http.post(
        genPicRl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $uAccessToken",
        },
        body: jsonEncode(variables),
        // body: jsonEncode({'query': query, 'variables': variables}),
      );

      var body = jsonDecode(response.body);
      debugPrint("Kookay: $variables");
      return {respGood: true, respBody: body};
    } catch (e) {
      debugPrint("Kooked: $variables");
      return {
        respGood: false,
        respBody: {respError: "$e"},
      };
    }
  }
}
