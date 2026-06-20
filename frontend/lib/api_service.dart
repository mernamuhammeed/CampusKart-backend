import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // --- SMART URL DETECTION ---
  // Automatically detects if it's running on Render or Localhost
  static String get baseUrl {
    if (kIsWeb) {
      final origin = Uri.base.origin;
      // If running locally in Chrome, point to the backend port (3000)
      if (origin.contains('localhost') || origin.contains('127.0.0.1')) {
        return "http://localhost:3000";
      }
      return origin;
    }
    // For local mobile testing (Android emulator uses 10.0.2.2)
    return "http://localhost:3000"; 
  }

  // --- 1. SIGN UP ---
  static Future<String> signupUser(String email, String password, String name) async {
    final String apiUrl = "$baseUrl/api/signup";
    debugPrint("🟡 SIGNUP REQ: $email, name: $name");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password, "name": name}),
      );

      debugPrint("🔵 SIGNUP RESP: ${response.body}");
      debugPrint("🔵 STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 201) {
        return "Success";
      } else {
        try {
          final error = jsonDecode(response.body)['error'];
          return error ?? "Signup failed";
        } catch (_) {
          return "Server error: ${response.statusCode}";
        }
      }
    } catch (e) {
      debugPrint("❌ CONNECTION ERROR: $e");
      return "Connection error";
    }
  }

  // --- 2. LOGIN ---
  static Future<String> loginUser(String email, String password) async {
    final String apiUrl = "$baseUrl/api/login";
    debugPrint("🟢 LOGIN REQ: $email");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      debugPrint("🔵 LOGIN RESP: ${response.body}");
      debugPrint("🔵 STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          final responseBody = jsonDecode(response.body);
          final message = responseBody['message'];
          final name = responseBody['name'] ?? '';

          if (message == 'AdminSuccess') return 'AdminSuccess';
          return "Success:$name";
        } catch (_) {
          return "Invalid server response";
        }
      } else {
        return "Login failed (Status: ${response.statusCode})";
      }
    } catch (e) {
      debugPrint("❌ LOGIN ERROR: $e");
      return "Connection error";
    }
  }

  // --- 3. RIDE REQUEST ---
  static Future<String?> sendRideRequest(
    String studentEmail,
    String pickupName,
    String destName
  ) async {
    final String apiUrl = "$baseUrl/api/confirm-ride";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "studentEmail": studentEmail,
          "pickup": {
            "name": pickupName
          },
          "destination": {
            "name": destName
          },
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['rideId'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // --- 4. GET RIDE STATUS ---
  static Future<Map<String, dynamic>?> getRide(String rideId) async {
    final String apiUrl = "$baseUrl/api/ride/$rideId";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Get ride error: $e");
    }
    return null;
  }

  // --- 4b. RATE RIDE ---
  static Future<bool> rateRide(String rideId, int rating, String feedback) async {
    final String apiUrl = "$baseUrl/api/ride/rate";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"rideId": rideId, "rating": rating, "feedback": feedback}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Rate ride error: $e");
      return false;
    }
  }

  // --- 4c. CANCEL RIDE ---
  static Future<bool> cancelRide(String rideId) async {
    final String apiUrl = "$baseUrl/api/ride/$rideId/cancel";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Cancel ride error: $e");
      return false;
    }
  }

  // --- 5. TELEMETRY GET ---
  static Future<Map<String, dynamic>> getLatestTelemetry() async {
    final String apiUrl = "$baseUrl/api/telemetry/latest";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Telemetry error: $e");
    }
    return {};
  }

  // --- ADMIN: GET STATS ---
  static Future<Map<String, dynamic>> getAdminStats() async {
    final String apiUrl = "$baseUrl/api/admin/stats";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { debugPrint("Admin stats error: $e"); }
    return {};
  }

  // --- ADMIN: GET ALL RIDES ---
  static Future<List<dynamic>> getAllRides() async {
    final String apiUrl = "$baseUrl/api/admin/rides";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { debugPrint("Admin rides error: $e"); }
    return [];
  }

  // --- ADMIN: GET ALL USERS ---
  static Future<List<dynamic>> getAllUsers() async {
    final String apiUrl = "$baseUrl/api/admin/users";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { debugPrint("Admin users error: $e"); }
    return [];
  }

  // --- ADMIN: GET ANALYTICS ---
  static Future<Map<String, dynamic>> getRideAnalytics() async {
    final String apiUrl = "$baseUrl/api/admin/analytics/rides";
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Accept": "application/json"},
      ).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("Ride analytics HTTP ${response.statusCode}: ${response.body.substring(0, response.body.length.clamp(0, 200))}");
      }
    } catch (e) { debugPrint("Ride analytics error: $e"); }
    // Return empty scaffold so UI doesn't crash
    return {
      'totalTrips': 0,
      'mtbr': '0.0 min',
      'hourlyCounts': List.filled(24, 0),
      'ratingsDistribution': {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
      'feedbackFeed': [],
    };
  }

  static Future<Map<String, dynamic>> getStationAnalytics() async {
    final String apiUrl = "$baseUrl/api/admin/analytics/stations";
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Accept": "application/json"},
      ).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("Station analytics HTTP ${response.statusCode}: ${response.body.substring(0, response.body.length.clamp(0, 200))}");
      }
    } catch (e) { debugPrint("Station analytics error: $e"); }
    return {'pickups': [], 'destinations': []};
  }

  static Future<Map<String, dynamic>> getVehicleAnalytics() async {
    final String apiUrl = "$baseUrl/api/admin/analytics/vehicles";
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Accept": "application/json"},
      ).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) { debugPrint("Vehicle analytics error: $e"); }
    return {'vehicles': []};
  }

  // --- ADMIN: MANUAL CONTROL ---
  static Future<Map<String, dynamic>> getAdminControl() async {
    final String apiUrl = "$baseUrl/api/admin/control";
    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) { debugPrint("Get admin control error: $e"); }
    return {};
  }

  static Future<bool> postAdminControl(Map<String, dynamic> controlData) async {
    final String apiUrl = "$baseUrl/api/admin/control";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(controlData),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Post admin control error: $e");
      return false;
    }
  }
}
