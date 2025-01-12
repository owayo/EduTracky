import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/child.dart';

final childrenProvider =
    AsyncNotifierProvider<ChildrenNotifier, List<Child>>(() => ChildrenNotifier());

class ChildrenNotifier extends AsyncNotifier<List<Child>> {
  @override
  Future<List<Child>> build() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    return _fetchChildren();
  }

  Future<List<Child>> _fetchChildren() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('children')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Child.fromJson({
        ...data,
        'id': doc.id,
        'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
        'updatedAt': (data['updatedAt'] as Timestamp).toDate().toIso8601String(),
      });
    }).toList();
  }

  Future<void> addChild(Child child) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    state = const AsyncValue.loading();

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('children')
          .add(child.toJson()..remove('id'));

      final newChild = child.copyWith(id: docRef.id);
      final currentChildren = await _fetchChildren();

      state = AsyncValue.data([newChild, ...currentChildren]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateChild(Child child) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    state = const AsyncValue.loading();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('children')
          .doc(child.id)
          .update(child.toJson()..remove('id'));

      final currentChildren = await _fetchChildren();
      state = AsyncValue.data(currentChildren);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteChild(String childId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    state = const AsyncValue.loading();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('children')
          .doc(childId)
          .delete();

      final currentChildren = await _fetchChildren();
      state = AsyncValue.data(currentChildren);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}