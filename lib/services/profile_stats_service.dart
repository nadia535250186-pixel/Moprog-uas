import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileStatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Memperbarui statistik setelah pengguna menyelesaikan pelajaran
  Future<void> completeLesson({int earnedXp = 10}) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    if (earnedXp < 0) {
      throw Exception('XP tidak boleh negatif');
    }

    final userRef = _firestore
        .collection('users')
        .doc(user.uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception('Data pengguna tidak ditemukan');
      }

      final data = snapshot.data() ?? {};

      final currentXp = (data['xp'] as num?)?.toInt() ?? 0;
      final completedLessons =
          (data['completedLessons'] as num?)?.toInt() ?? 0;

      final today = DateTime.now();
      final todayDate =
          '${today.year}-${today.month}-${today.day}';

      final lastStudyDate = data['lastStudyDate'] as String?;

      int currentStreak =
          (data['learningStreak'] as num?)?.toInt() ?? 0;

      if (lastStudyDate != todayDate) {
        final yesterday = today.subtract(
          const Duration(days: 1),
        );

        final yesterdayDate =
            '${yesterday.year}-${yesterday.month}-${yesterday.day}';

        if (lastStudyDate == yesterdayDate) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
      }

      transaction.update(userRef, {
        'xp': currentXp + earnedXp,
        'completedLessons': completedLessons + 1,
        'learningStreak': currentStreak,
        'lastStudyDate': todayDate,
      });
    });
  }
}
