import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/case_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../models/case.dart';
import '../../widgets/case_card.dart';
import '../../widgets/stats_card.dart';
import 'case_details_screen.dart';
import 'donation_screen.dart';

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  double _radiusFilter = 50;
  CaseType? _typeFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final caseProvider = Provider.of<CaseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Browse Cases'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _showProfileMenu(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => caseProvider.loadCases(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Make a Difference Today',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome back, ${authProvider.currentUser?.phoneNumber ?? 'Donor'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSearchBar(),
                          const SizedBox(height: 16),
                          _buildFilterChips(),
                        ],
                      ),
                    ),
                    _buildStatsRow(caseProvider),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: caseProvider.isLoading
                  ? const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : caseProvider.cases.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'No cases found',
                              style: TextStyle(fontSize: 18, color: AppTheme.textLight),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final caseItem = caseProvider.cases[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: CaseCard(
                                  caseItem: caseItem,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CaseDetailsScreen(caseItem: caseItem),
                                      ),
                                    );
                                  },
                                  onDonate: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DonationScreen(caseItem: caseItem),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            childCount: caseProvider.cases.length,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search cases...',
          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<CaseProvider>().searchCases('');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          context.read<CaseProvider>().searchCases(value);
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            label: 'All',
            isSelected: _typeFilter == null,
            onSelected: (selected) {
              setState(() {
                _typeFilter = null;
              });
              context.read<CaseProvider>().setFilterType(null);
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Medical',
            isSelected: _typeFilter == CaseType.medical,
            onSelected: (selected) {
              setState(() {
                _typeFilter = selected ? CaseType.medical : null;
              });
              context.read<CaseProvider>().setFilterType(_typeFilter);
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Education',
            isSelected: _typeFilter == CaseType.education,
            onSelected: (selected) {
              setState(() {
                _typeFilter = selected ? CaseType.education : null;
              });
              context.read<CaseProvider>().setFilterType(_typeFilter);
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Emergency',
            isSelected: _typeFilter == CaseType.emergency,
            onSelected: (selected) {
              setState(() {
                _typeFilter = selected ? CaseType.emergency : null;
              });
              context.read<CaseProvider>().setFilterType(_typeFilter);
            },
          ),
          const SizedBox(width: 8),
          _buildRadiusFilter(),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: AppTheme.secondaryCyan.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildRadiusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 16, color: AppTheme.primaryBlue),
          const SizedBox(width: 4),
          DropdownButton<double>(
            value: _radiusFilter,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 5, child: Text('5 km')),
              DropdownMenuItem(value: 10, child: Text('10 km')),
              DropdownMenuItem(value: 25, child: Text('25 km')),
              DropdownMenuItem(value: 50, child: Text('50 km')),
              DropdownMenuItem(value: 100, child: Text('100 km')),
              DropdownMenuItem(value: 500, child: Text('500 km')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _radiusFilter = value;
                });
                context.read<CaseProvider>().setFilterRadius(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(CaseProvider caseProvider) {
    final activeCases = caseProvider.cases.where((c) => c.status == CaseStatus.active).length;
    final totalRaised = caseProvider.cases.fold<double>(
      0,
      (sum, c) => sum + c.raisedAmount,
    );
    final verifiedCases = caseProvider.cases.where((c) => c.isImamVerified).length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: StatsCard(
              title: 'Active Cases',
              value: activeCases.toString(),
              icon: Icons.cases_outlined,
              color: AppTheme.secondaryCyan,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatsCard(
              title: 'Total Raised',
              value: 'Rs ${(totalRaised / 1000).toStringAsFixed(0)}K',
              icon: Icons.monetization_on,
              color: AppTheme.successGreen,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatsCard(
              title: 'Verified',
              value: verifiedCases.toString(),
              icon: Icons.verified,
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.primaryBlue,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                authProvider.currentUser?.phoneNumber ?? 'Donor',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'CNIC: ${authProvider.currentUser?.cnic ?? 'N/A'}',
                style: const TextStyle(color: AppTheme.textLight),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.history, color: AppTheme.primaryBlue),
                title: const Text('Donation History'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: AppTheme.primaryBlue),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.errorRed),
                title: const Text('Logout'),
                onTap: () {
                  authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/role-selection');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}