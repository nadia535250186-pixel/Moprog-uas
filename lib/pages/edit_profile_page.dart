import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  String oldUsername = '';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = document.data();

      if (data != null) {
        nameController.text = data['fullName'] ?? '';
        oldUsername = data['username'] ?? '';
        usernameController.text = oldUsername;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final fullName = nameController.text.trim();
    final newUsername =
        usernameController.text.trim().toLowerCase();

    if (fullName.isEmpty || newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi')),
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$')
        .hasMatch(newUsername)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username harus 3-20 karakter, hanya huruf, angka, dan underscore',
          ),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final firestore = FirebaseFirestore.instance;
      final userRef = firestore.collection('users').doc(user.uid);

      if (newUsername != oldUsername) {
        final newUsernameRef =
            firestore.collection('usernames').doc(newUsername);

        final oldUsernameRef =
            firestore.collection('usernames').doc(oldUsername);

        await firestore.runTransaction((transaction) async {
          final usernameSnapshot =
              await transaction.get(newUsernameRef);

          if (usernameSnapshot.exists) {
            throw Exception('USERNAME_TAKEN');
          }

          transaction.set(newUsernameRef, {
            'uid': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });

          transaction.delete(oldUsernameRef);

          transaction.update(userRef, {
            'fullName': fullName,
            'username': newUsername,
          });
        });
      } else {
        await userRef.update({
          'fullName': fullName,
        });
      }

      await user.updateDisplayName(fullName);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      String message = 'Gagal memperbarui profil';

      if (e.toString().contains('USERNAME_TAKEN')) {
        message = 'Username sudah digunakan orang lain';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FFF5),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7FFF5),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF58CC02),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFDFF5DF),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF58CC02),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      hintText: 'Enter your full name',
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(),
                      hintText: 'Enter your username',
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    '3-20 karakter. Gunakan huruf, angka, atau underscore.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      child: isSaving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'SAVE CHANGES',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
