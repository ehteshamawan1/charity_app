import 'package:flutter/material.dart';
import '../models/case.dart';
import '../utils/theme.dart';

class CaseCard extends StatelessWidget {
  final Case caseItem;
  final VoidCallback onTap;
  final VoidCallback onDonate;

  const CaseCard({
    super.key,
    required this.caseItem,
    required this.onTap,
    required this.onDonate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _getTypeColor(caseItem.type).withOpacity(0.2),
                        child: Icon(
                          _getTypeIcon(caseItem.type),
                          color: _getTypeColor(caseItem.type),
                          size: 20,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    caseItem.location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildTypeBadge(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    caseItem.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    caseItem.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (caseItem.isImamVerified)
                        _buildVerificationBadge(
                          'Imam Verified',
                          Icons.mosque,
                          AppTheme.primaryBlue,
                        ),
                      if (caseItem.isImamVerified && caseItem.isAdminApproved)
                        const SizedBox(width: 8),
                      if (caseItem.isAdminApproved)
                        _buildVerificationBadge(
                          'Admin Approved',
                          Icons.verified_user,
                          AppTheme.successGreen,
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
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: caseItem.progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            caseItem.progress >= 0.8
                                ? AppTheme.successGreen
                                : AppTheme.secondaryCyan,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      Icon(
                        Icons.mosque,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          caseItem.mosqueName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onDonate,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(
                      child: Text(
                        'DONATE NOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(caseItem.type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getTypeColor(caseItem.type).withOpacity(0.3),
        ),
      ),
      child: Text(
        _getTypeLabel(caseItem.type),
        style: TextStyle(
          fontSize: 11,
          color: _getTypeColor(caseItem.type),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVerificationBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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