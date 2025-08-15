import 'package:flutter/material.dart';
import '../../models/case.dart';
import '../../utils/theme.dart';
import 'donation_screen.dart';

class CaseDetailsScreen extends StatelessWidget {
  final Case caseItem;

  const CaseDetailsScreen({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getTypeColor(caseItem.type),
                      _getTypeColor(caseItem.type).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getTypeIcon(caseItem.type),
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getTypeLabel(caseItem.type),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      caseItem.beneficiaryName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: AppTheme.textLight,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          caseItem.location,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            caseItem.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            caseItem.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textLight,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Funding Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Raised',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textLight,
                                    ),
                                  ),
                                  Text(
                                    'Rs ${caseItem.raisedAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.successGreen,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Target',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textLight,
                                    ),
                                  ),
                                  Text(
                                    'Rs ${caseItem.targetAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: caseItem.progress,
                              minHeight: 12,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                caseItem.progress >= 0.8
                                    ? AppTheme.successGreen
                                    : AppTheme.secondaryCyan,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              '${(caseItem.progress * 100).toStringAsFixed(1)}% completed',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verification',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            leading: Icon(
                              Icons.mosque,
                              color: caseItem.isImamVerified
                                  ? AppTheme.primaryBlue
                                  : Colors.grey,
                            ),
                            title: const Text('Imam Verification'),
                            subtitle: Text(caseItem.mosqueName),
                            trailing: caseItem.isImamVerified
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppTheme.successGreen,
                                  )
                                : const Icon(
                                    Icons.pending,
                                    color: Colors.grey,
                                  ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.admin_panel_settings,
                              color: caseItem.isAdminApproved
                                  ? AppTheme.successGreen
                                  : Colors.grey,
                            ),
                            title: const Text('Admin Approval'),
                            subtitle: Text(
                              caseItem.isAdminApproved ? 'Approved' : 'Pending',
                            ),
                            trailing: caseItem.isAdminApproved
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppTheme.successGreen,
                                  )
                                : const Icon(
                                    Icons.pending,
                                    color: Colors.grey,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DonationScreen(caseItem: caseItem),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppTheme.primaryBlue,
          ),
          child: const Text(
            'DONATE NOW',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(CaseType type) {
    switch (type) {
      case CaseType.medical:
        return AppTheme.errorRed;
      case CaseType.education:
        return AppTheme.primaryBlue;
      case CaseType.emergency:
        return AppTheme.warningOrange;
      case CaseType.housing:
        return Colors.brown;
      case CaseType.food:
        return AppTheme.successGreen;
      default:
        return AppTheme.textLight;
    }
  }

  IconData _getTypeIcon(CaseType type) {
    switch (type) {
      case CaseType.medical:
        return Icons.local_hospital;
      case CaseType.education:
        return Icons.school;
      case CaseType.emergency:
        return Icons.warning;
      case CaseType.housing:
        return Icons.home;
      case CaseType.food:
        return Icons.restaurant;
      default:
        return Icons.help;
    }
  }

  String _getTypeLabel(CaseType type) {
    switch (type) {
      case CaseType.medical:
        return 'Medical';
      case CaseType.education:
        return 'Education';
      case CaseType.emergency:
        return 'Emergency';
      case CaseType.housing:
        return 'Housing';
      case CaseType.food:
        return 'Food';
      default:
        return 'Other';
    }
  }
}