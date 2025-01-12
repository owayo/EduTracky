import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'child.freezed.dart';
part 'child.g.dart';

@freezed
class Child with _$Child {
  const factory Child({
    required String id,
    required String name,
    required DateTime birthDate,  // 生年月日に変更
    String? note,           // メモ（任意）
    required DateTime createdAt,  // 登録日
    required DateTime updatedAt,  // 更新日
  }) = _Child;

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
}