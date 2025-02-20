import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wo1/Models/user_details.dart';

final storage = FlutterSecureStorage(); // Create a storage instance

class ApiHandler {
  // Constructor

  // ignore: constant_identifier_names
  static const String APISERVERADDRESS = "https://wo1.api.vrianta.in";
  // static const String APISERVERADDRESS = "http://192.168.0.104:8080";
  static List<String> cookies = [];
  static String? cookieHeader = "";
  String response = '';
  // ignore: non_constant_identifier_names
  static String api_token = '';
  static String uid = '';
  static String isActivated = '';
  static String accountType = '';
  static UserDetails userDetails = UserDetails(
    userId: "userId",
    fullName: "fullName",
    email: "demo@mail.com",
    phoneNumber: "phoneNumber",
    photoUrl: "photoUrl",
    rating: 0,
    experienceYear: 0,
    workDone: 0,
    dateOfBirth: "dateOfBirth",
    height: "height",
    age: 0,
    gender: "",
  );

  String getUserDetails() {
    return "userDetails";
  }

  // Login method
  Future<String> login(String userid, String password) async {
    await _initResponse("get-token", {
      "uid": userid,
      "password": password,
    });
    return response;
  }

  // Register method
  Future<String> register(
    String userid,
    String fullName,
    String password,
    String emailId,
    String phoneNumber,
  ) async {
    await _initResponse("register", {
      "uid": userid,
      "fullname": fullName,
      "password": password,
      "phone_number": phoneNumber,
      "email": emailId,
    });

    return response;
  }

  // Register method with OTP
  Future<void> registerWithOtp(String userid, String fullName, String password,
      String emailId, String phoneNumber, String otp) async {
    await _initResponse("register", {
      "uid": userid,
      "fullname": fullName,
      "password": password,
      "phone_number": phoneNumber,
      "email": emailId,
      "otp": otp,
    });
  }

  // Create event method
  Future<String> createEvent({
    required String eventName,
    required String eventType,
    required String requirement,
    required String budget,
    required String minHeight,
    required String minRating,
    required String minAge,
    required String date,
    required String time,
    required String foodProvided,
    required String language,
    required String location,
  }) async {
    await _initResponse("create-event", {
      "uid": uid,
      "token": api_token,
      "eventName": eventName,
      "type": eventType,
      "requirement": requirement.toString(),
      "budget": budget.toString(),
      "minHeight": minHeight,
      "minRating": minRating.toString(),
      "minAge": minAge.toString(),
      "date": date,
      "time": time,
      "foodProvided": foodProvided.toString(),
      "language": language,
      "location": location,
    });
    return response;
  }

  // Get contents method
  Future<String> getEvents(int lastIndex) async {
    await _initResponse("get-contents", {
      "uid": uid,
      "token": api_token,
      "last_event_index": lastIndex.toString(),
    });

    return response;
  }

  // Get contents method
  Future<String> getEventsByType(int lastIndex, String eventType) async {
    await _initResponse("get-events-by-type", {
      "uid": uid,
      "token": api_token,
      "last_event_index": lastIndex.toString(),
      "event_type": eventType,
    });

    return response;
  }

  // Get applied events method
  Future<String> getAppliedEvents() async {
    await _initResponse("get-applied-events", {
      "uid": uid,
      "token": api_token,
    });

    return response;
  }

  // Apply to an event method
  Future<String> applyToEvent(String eventId) async {
    await _initResponse("apply-to-event", {
      "uid": uid,
      "token": api_token,
      "eventid": eventId,
    });

    return response;
  }

  // Withdraw from an event method
  Future<String> withdrawFromEvent(String eventId) async {
    await _initResponse("withdraw-from-event", {
      "uid": uid,
      "token": api_token,
      "eventid": eventId,
    });

    return response;
  }

  // Login method
  Future<String> updateUser(String email) async {
    await _initResponse("update-user", {
      "uid": uid,
      "token": api_token,
      "email": email,
    });
    return response;
  }

  // Get notifications method
  Future<String> getNotifications() async {
    await _initResponse("get-notification", {
      "uid": uid,
      "token": api_token,
    });

    return response;
  }

  // Get notifications method
  Future<String> deleteNotifications(String description) async {
    await _initResponse("delete-notification", {
      "uid": uid,
      "token": api_token,
      "description": description,
    });

    return response;
  }

  // Logout method
  Future<void> logout() async {
    await _initResponse("/logout", {});
    // Clear saved credentials and cookies
    await storage.delete(key: 'cookies');
    await storage.delete(key: "username");
    await storage.delete(key: "password");
    cookies.clear();
    cookieHeader = "";
    api_token = '';
    uid = '';
    accountType = '';
  }

  /// Return all the event realted information for the buisness owener
  /// return data will be
  /// Success : true
  /// CODE : EVENTPROGRESS
  /// Manager: manager details
  /// Recruitments: users who are recruited for the event
  Future<String> getEventsCreatedByBuisness(String evnetid) async {
    await _initResponse("get-event-assingments", {
      "uid": uid,
      "token": api_token,
      "event_id": evnetid,
    });

    return response;
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
