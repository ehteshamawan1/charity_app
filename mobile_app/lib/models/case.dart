class Case {
  final String id;
  final String beneficiaryName;
  final String beneficiaryId;
  final String title;
  final String description;
  final CaseType type;
  final double targetAmount;
  final double raisedAmount;
  final String location;
  final String mosqueId;
  final String mosqueName;
  final bool isImamVerified;
  final bool isAdminApproved;
  final CaseStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? documents;

  Case({
    required this.id,
    required this.beneficiaryName,
    required this.beneficiaryId,
    required this.title,
    required this.description,
    required this.type,
    required this.targetAmount,
    this.raisedAmount = 0,
    required this.location,
    required this.mosqueId,
    required this.mosqueName,
    this.isImamVerified = false,
    this.isAdminApproved = false,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.documents,
  });

  double get progress => targetAmount > 0 ? (raisedAmount / targetAmount) : 0;
  double get remainingAmount => targetAmount - raisedAmount;

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['id'],
      beneficiaryName: json['beneficiaryName'],
      beneficiaryId: json['beneficiaryId'],
      title: json['title'],
      description: json['description'],
      type: CaseType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      targetAmount: json['targetAmount'].toDouble(),
      raisedAmount: (json['raisedAmount'] ?? 0).toDouble(),
      location: json['location'],
      mosqueId: json['mosqueId'],
      mosqueName: json['mosqueName'],
      isImamVerified: json['isImamVerified'] ?? false,
      isAdminApproved: json['isAdminApproved'] ?? false,
      status: CaseStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      documents: json['documents'] != null ? List<String>.from(json['documents']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beneficiaryName': beneficiaryName,
      'beneficiaryId': beneficiaryId,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'targetAmount': targetAmount,
      'raisedAmount': raisedAmount,
      'location': location,
      'mosqueId': mosqueId,
      'mosqueName': mosqueName,
      'isImamVerified': isImamVerified,
      'isAdminApproved': isAdminApproved,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'documents': documents,
    };
  }
}

enum CaseType { medical, education, emergency, housing, food, other }
enum CaseStatus { pending, active, completed, rejected }