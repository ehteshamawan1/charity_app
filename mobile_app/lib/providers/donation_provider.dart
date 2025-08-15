import 'package:flutter/material.dart';

class Donation {
  final String id;
  final String donorId;
  final String caseId;
  final double amount;
  final DateTime timestamp;
  final String paymentMethod;

  Donation({
    required this.id,
    required this.donorId,
    required this.caseId,
    required this.amount,
    required this.timestamp,
    this.paymentMethod = 'Mock Payment',
  });
}

class DonationProvider extends ChangeNotifier {
  final List<Donation> _donations = [];
  bool _isProcessing = false;
  String? _error;

  List<Donation> get donations => _donations;
  bool get isProcessing => _isProcessing;
  String? get error => _error;

  double get totalDonated => _donations.fold(0, (sum, d) => sum + d.amount);

  Future<bool> makeDonation({
    required String donorId,
    required String caseId,
    required double amount,
  }) async {
    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final donation = Donation(
        id: 'don_${DateTime.now().millisecondsSinceEpoch}',
        donorId: donorId,
        caseId: caseId,
        amount: amount,
        timestamp: DateTime.now(),
      );
      
      _donations.add(donation);
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  List<Donation> getDonationsByCaseId(String caseId) {
    return _donations.where((d) => d.caseId == caseId).toList();
  }

  List<Donation> getDonationsByDonorId(String donorId) {
    return _donations.where((d) => d.donorId == donorId).toList();
  }
}