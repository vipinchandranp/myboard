import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_models/main_response.dart';
import '../models/payment/PaymentRequest.dart';
import '../models/payment/PaymentResponse.dart';
import '../types/status_type.dart';
import 'base_repository.dart';

class PaymentService extends BaseRepository {
  PaymentService(BuildContext context) : super(context);

  // Method to fetch the display price based on the displayId
  Future<double?> getDisplayPrice(String displayId) async {
    try {
      final url = Uri.parse('$apiUrl/payment/display/price?displayId=$displayId');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final price = data['price'];

        if (price is num) {
          return price.toDouble() != 0.0 ? price.toDouble() : null;
        } else {
          throw FormatException('Invalid price format');
        }
      } else {
        throw Exception('Failed to load display price');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to initiate payment
  Future<String> initiatePayment(PaymentRequest request) async {
    try {
      final url = Uri.parse('$apiUrl/payment/initiate');
      final paymentData = json.encode(request.toJson());

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: paymentData,
      );

      return extractDataFromResponseBody(response);

    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to process payment
  Future<String> processPayment(PaymentRequest request) async {
    try {
      final url = Uri.parse('$apiUrl/payment/process');
      final paymentData = json.encode(request.toJson());

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: paymentData,
      );

      if (response.statusCode == 200) {
        return extractDataFromResponseBody(response);
      } else {
        throw Exception('Failed to process payment');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to check the status of a payment
  Future<MainResponse<PaymentResponse>> checkPaymentStatus(String transactionId) async {
    try {
      final url = Uri.parse('$apiUrl/payment/status/$transactionId');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MainResponse<PaymentResponse>.fromJson(data, (json) => PaymentResponse.fromJson(json));
      } else {
        throw Exception('Failed to check payment status');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to update payment status
  Future<MainResponse<String>> updatePaymentStatus(String transactionId, StatusType newStatus) async {
    try {
      final url = Uri.parse('$apiUrl/payment/update-status/$transactionId?newStatus=$newStatus');
      final response = await client.put(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MainResponse<String>.fromJson(data, (json) => data['message'] ?? '');
      } else {
        throw Exception('Failed to update payment status');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
  // Method to calculate the price
  Future<double?> calculatePrice(String displayId, List<String> timeSlots, String date) async {
    try {
      final url = Uri.parse('$apiUrl/payment/calculate-price');
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'displayId': displayId,
          'timeSlots': timeSlots,
          'date': date,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];  // Return the calculated price
      } else {
        throw Exception('Failed to calculate price');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

}
