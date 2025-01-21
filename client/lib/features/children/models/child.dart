class Child {
  final String? id;
  final String name;
  final DateTime birthDate;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Child({
    this.id,
    required this.name,
    required this.birthDate,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  Child copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'note': note,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] as String?,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }
}