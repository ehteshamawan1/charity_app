import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/case_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../models/case.dart';
import 'submit_case_screen.dart';

class BeneficiaryHomeScreen extends StatelessWidget {
  const BeneficiaryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final caseProvider = Provider.of<CaseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    final myCases = caseProvider.cases.where(
      (c) => c.beneficiaryId == authProvider.currentUser?.id,
    ).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Beneficiary Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/role-selection');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => caseProvider.loadCases(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.successGreen, AppTheme.successGreen.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.currentUser?.phoneNumber ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        size: 48,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Need Assistance?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Submit your case for help. Our team will review and verify your request.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubmitCaseScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Submit New Case'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'My Cases',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              if (myCases.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No cases submitted yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Submit your first case to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...myCases.map((caseItem) => _buildCaseCard(caseItem)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaseCard(Case caseItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(caseItem.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusLabel(caseItem.status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(caseItem.status),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(caseItem.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getTypeLabel(caseItem.type),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getTypeColor(caseItem.type),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              caseItem.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              caseItem.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textLight,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.mosque, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  caseItem.mosqueName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs ${(caseItem.raisedAmount / 1000).toStringAsFixed(0)}K raised',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    Text(
                      'of Rs ${(caseItem.targetAmount / 1000).toStringAsFixed(0)}K',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: caseItem.progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      caseItem.progress >= 0.8
                          ? AppTheme.successGreen
                          : AppTheme.secondaryCyan,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(caseItem.progress * 100).toStringAsFixed(0)}% completed',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (caseItem.isImamVerified)
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 14, color: AppTheme.primaryBlue),
                      const SizedBox(width: 4),
                      const Text(
                        'Imam Verified',
                        style: TextStyle(fontSize: 11, color: AppTheme.primaryBlue),
                      ),
                    ],
                  ),
                if (caseItem.isImamVerified && caseItem.isAdminApproved)
                  const SizedBox(width: 12),
                if (caseItem.isAdminApproved)
                  Row(
                    children: [
                      Icon(Icons.verified_user, size: 14, color: AppTheme.successGreen),
                      const SizedBox(width: 4),
                      const Text(
                        'Admin Approved',
                        style: TextStyle(fontSize: 11, color: AppTheme.successGreen),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(CaseStatus status) {
    switch (status) {
      case CaseStatus.active:
        return AppTheme.successGreen;
      case CaseStatus.pending:
        return AppTheme.warningOrange;
      case CaseStatus.completed:
        return AppTheme.primaryBlue;
      case CaseStatus.rejected:
        return AppTheme.errorRed;
    }
  }

  String _getStatusLabel(CaseStatus status) {
    switch (status) {
      case CaseStatus.active:
        return 'Active';
      case CaseStatus.pending:
        return 'Pending';
      case CaseStatus.completed:
        return 'Completed';
      case CaseStatus.rejected:
        return 'Rejected';
    }
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