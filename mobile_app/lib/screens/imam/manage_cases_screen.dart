import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/case_provider.dart';
import '../../models/case.dart';
import '../../utils/theme.dart';

class ManageCasesScreen extends StatelessWidget {
  const ManageCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final caseProvider = Provider.of<CaseProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundGrey,
        appBar: AppBar(
          title: const Text('Manage Cases'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCaseList(
              caseProvider.cases.where((c) => c.status == CaseStatus.active).toList(),
              'No active cases',
            ),
            _buildCaseList(
              caseProvider.cases.where((c) => c.status == CaseStatus.pending).toList(),
              'No pending cases',
            ),
            _buildCaseList(
              caseProvider.cases.where((c) => c.status == CaseStatus.completed).toList(),
              'No completed cases',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseList(List<Case> cases, String emptyMessage) {
    if (cases.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16, color: AppTheme.textLight),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cases.length,
      itemBuilder: (context, index) {
        final caseItem = cases[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(caseItem.status).withOpacity(0.2),
              child: Icon(
                _getStatusIcon(caseItem.status),
                color: _getStatusColor(caseItem.status),
              ),
            ),
            title: Text(
              caseItem.beneficiaryName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(caseItem.title),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(caseItem.progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(caseItem.status),
                  ),
                ),
                Text(
                  'Rs ${(caseItem.targetAmount / 1000).toStringAsFixed(0)}K',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caseItem.description,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Location',
                            caseItem.location,
                            Icons.location_on,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Type',
                            _getTypeLabel(caseItem.type),
                            Icons.category,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Raised',
                            'Rs ${caseItem.raisedAmount.toStringAsFixed(0)}',
                            Icons.monetization_on,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Remaining',
                            'Rs ${caseItem.remainingAmount.toStringAsFixed(0)}',
                            Icons.pending_actions,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (caseItem.isImamVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 14, color: AppTheme.primaryBlue),
                                SizedBox(width: 4),
                                Text(
                                  'Imam Verified',
                                  style: TextStyle(fontSize: 12, color: AppTheme.primaryBlue),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(width: 8),
                        if (caseItem.isAdminApproved)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 14, color: AppTheme.successGreen),
                                SizedBox(width: 4),
                                Text(
                                  'Admin Approved',
                                  style: TextStyle(fontSize: 12, color: AppTheme.successGreen),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showEditDialog(context, caseItem);
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: caseItem.status == CaseStatus.pending
                                ? () {
                                    _verifyCase(context, caseItem);
                                  }
                                : null,
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Verify'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textLight),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, Case caseItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Case'),
        content: const Text('Edit functionality will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _verifyCase(BuildContext context, Case caseItem) {
    final caseProvider = Provider.of<CaseProvider>(context, listen: false);
    caseProvider.updateCase(caseItem.id, {
      'isImamVerified': true,
      'status': CaseStatus.active.toString().split('.').last,
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Case verified successfully'),
        backgroundColor: AppTheme.successGreen,
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

  IconData _getStatusIcon(CaseStatus status) {
    switch (status) {
      case CaseStatus.active:
        return Icons.play_circle;
      case CaseStatus.pending:
        return Icons.pending;
      case CaseStatus.completed:
        return Icons.check_circle;
      case CaseStatus.rejected:
        return Icons.cancel;
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