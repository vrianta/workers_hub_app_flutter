import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage(); // Create a storage instance

class ApiHandler {
  // ignore: constant_identifier_names
  static const String APISERVERADDRESS = "http://192.168.1.105:8082";
  static List<String> cookies = [];
  static String? cookieHeader = "";
  String response = '';
  // ignore: non_constant_identifier_names
  static String api_token = '';
  static String uid = '';
  static String accountType = '';

  // Login method
  Future<String> login(String userid, String password) async {
    await _initResponse("get-token", {
      "uid": userid,
      "password": password,
    });
    return response;
  }

  // Register method
  Future<void> register(String userid, String fullName, String password) async {
    await _initResponse("register", {
      "uid": userid,
      "fullname": fullName,
      "password": password,
    });
  }

  // Create event method
  Future<void> createEvent() async {
    await _initResponse("create-event", {
      "uid": uid,
      "token": api_token,
    });
  }

  // Get contents method
  Future<String> get() async {
    await _initResponse("get-contents", {
      "uid": uid,
      "token": api_token,
    });

    return response;
  }

  // Get applied events method
  Future<void> getAppliedEvents() async {
    await _initResponse("get-applied-events", {
      "uid": uid,
      "token": api_token,
    });
  }

  // Apply to an event method
  Future<void> applyToEvent(String eventId) async {
    await _initResponse("apply-to-event", {
      "uid": uid,
      "token": api_token,
      "eventid": eventId,
    });
  }

  // Withdraw from an event method
  Future<void> withdrawFromEvent(String eventId) async {
    await _initResponse("withdraw-from-event", {
      "uid": uid,
      "token": api_token,
      "eventid": eventId,
    });
  }

  // Private method to handle HTTP POST request
  Future<void> _initResponse(
      String apiMethod, Map<String, String> postDataMap) async {
    response = "";

    var url = Uri.parse("$APISERVERADDRESS/$apiMethod");

    try {
      // Retrieve cookies from secure storage if available
      if (await storage.containsKey(key: "cookies")) {
        cookieHeader = await storage.read(key: 'cookies');
      }

      // Prepare headers
      Map<String, String> headers = {
        'Content-Type':
            'multipart/form-data; boundary=Boundary-${DateTime.now().millisecondsSinceEpoch}',
      };

      // Add cookies to the headers if any
      if (cookieHeader!.isNotEmpty) {
        headers['Cookie'] = cookieHeader!;
      } else if (cookies.isNotEmpty) {
        headers['Cookie'] = cookies.join('; ');
      }

      // Send the POST request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields.addAll(postDataMap);

      var streamedResponse = await request.send();

      // Get the response
      var responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        // Parse cookies from the response
        var cookieHeader = streamedResponse.headers['set-cookie'];
        if (cookieHeader != null) {
          cookies =
              cookieHeader.split(';').map((cookie) => cookie.trim()).toList();
          // Store cookies in secure storage
          await storage.write(key: 'cookies', value: cookies.join('; '));
        }
        response = responseBody;
      } else {
        response = json.encode({
          "SUCCESS": false,
          "ERROR": "Error: ${streamedResponse.statusCode}",
        });
      }
    } catch (e) {
      response = json.encode({
        "SUCCESS": false,
        "ERROR": "Exception in url hit: $e",
      });
    }
  }
}
