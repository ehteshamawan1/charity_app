import 'package:flutter/material.dart';
import '../models/case.dart';
import '../services/api_service.dart';

class CaseProvider extends ChangeNotifier {
  List<Case> _cases = [];
  List<Case> _filteredCases = [];
  bool _isLoading = false;
  String? _error;
  
  double _filterRadius = 50;
  CaseType? _filterType;
  String _searchQuery = '';

  List<Case> get cases => _filteredCases.isEmpty && _searchQuery.isEmpty && _filterType == null 
      ? _cases 
      : _filteredCases;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get filterRadius => _filterRadius;
  CaseType? get filterType => _filterType;

  final ApiService _apiService = ApiService();

  CaseProvider() {
    loadCases();
  }

  Future<void> loadCases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _cases = _generateMockCases();
      _filteredCases = _cases;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCases(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setFilterRadius(double radius) {
    _filterRadius = radius;
    _applyFilters();
  }

  void setFilterType(CaseType? type) {
    _filterType = type;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredCases = _cases.where((c) {
      bool matchesSearch = _searchQuery.isEmpty ||
          c.beneficiaryName.toLowerCase().contains(_searchQuery) ||
          c.title.toLowerCase().contains(_searchQuery) ||
          c.description.toLowerCase().contains(_searchQuery);
      
      bool matchesType = _filterType == null || c.type == _filterType;
      
      return matchesSearch && matchesType;
    }).toList();
    
    notifyListeners();
  }

  Future<bool> addCase(Case newCase) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _cases.insert(0, newCase);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCase(String caseId, Map<String, dynamic> updates) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = _cases.indexWhere((c) => c.id == caseId);
      if (index != -1) {
        final oldCase = _cases[index];
        final updatedCase = Case.fromJson({
          ...oldCase.toJson(),
          ...updates,
          'updatedAt': DateTime.now().toIso8601String(),
        });
        _cases[index] = updatedCase;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  List<Case> _generateMockCases() {
    return [
      Case(
        id: 'case_001',
        beneficiaryName: 'Sara Ahmed',
        beneficiaryId: 'ben_001',
        title: 'Urgent Medical Treatment for Heart Surgery',
        description: 'Sara Ahmed, a 45-year-old mother of three, urgently needs heart surgery. The family cannot afford the treatment costs.',
        type: CaseType.medical,
        targetAmount: 500000,
        raisedAmount: 125000,
        location: 'Karachi, Gulshan-e-Iqbal',
        mosqueId: 'mosque_001',
        mosqueName: 'Masjid Al-Noor',
        isImamVerified: true,
        isAdminApproved: true,
        status: CaseStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Case(
        id: 'case_002',
        beneficiaryName: 'Muhammad Ali',
        beneficiaryId: 'ben_002',
        title: 'Education Support for Orphan Children',
        description: 'Supporting education for three orphan children who lost their father. Need funds for school fees and supplies.',
        type: CaseType.education,
        targetAmount: 150000,
        raisedAmount: 75000,
        location: 'Lahore, Model Town',
        mosqueId: 'mosque_002',
        mosqueName: 'Jamia Masjid Model Town',
        isImamVerified: true,
        isAdminApproved: true,
        status: CaseStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Case(
        id: 'case_003',
        beneficiaryName: 'Fatima Bibi',
        beneficiaryId: 'ben_003',
        title: 'Emergency Food Assistance',
        description: 'Widow with 4 children needs urgent food assistance. Family has no source of income.',
        type: CaseType.food,
        targetAmount: 50000,
        raisedAmount: 45000,
        location: 'Islamabad, F-10',
        mosqueId: 'mosque_003',
        mosqueName: 'Faisal Mosque',
        isImamVerified: true,
        isAdminApproved: true,
        status: CaseStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Case(
        id: 'case_004',
        beneficiaryName: 'Abdul Rahman',
        beneficiaryId: 'ben_004',
        title: 'House Repair After Flood Damage',
        description: 'Family home severely damaged in recent floods. Need funds for basic repairs to make it livable.',
        type: CaseType.housing,
        targetAmount: 300000,
        raisedAmount: 50000,
        location: 'Multan, Cantt Area',
        mosqueId: 'mosque_004',
        mosqueName: 'Masjid-e-Aqsa',
        isImamVerified: true,
        isAdminApproved: false,
        status: CaseStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}