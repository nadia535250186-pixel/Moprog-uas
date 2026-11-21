import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'profile_photo_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfilePhotoService _photoService = ProfilePhotoService();

  File? _profilePhoto;
  bool _isLoadingPhoto = true;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  // Memuat foto profil berdasarkan UID pengguna
  Future<void> _loadProfilePhoto() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) return;

      final photo = await _photoService.loadPhoto(uid);

      if (!mounted) return;

      setState(() {
        _profilePhoto = photo;
        _isLoadingPhoto = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingPhoto = false;
      });
    }
  }

  // Memilih dan menyimpan foto profil
  Future<void> _pickProfilePhoto() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) return;

      final photo = await _photoService.pickPhoto(uid);

      if (!mounted || photo == null) return;

      setState(() {
        _profilePhoto = photo;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile photo updated successfully!'),
          backgroundColor: Color(0xFF58CC02),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select photo: $e'),
        ),
      );
    }
  }

  // Menghapus foto profil
  Future<void> _removeProfilePhoto() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) return;

      await _photoService.removePhoto(uid);

      if (!mounted) return;

      setState(() {
        _profilePhoto = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile photo removed'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove photo: $e'),
        ),
      );
    }
  }

  // Menu foto profil
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF58CC02),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickProfilePhoto();
                },
              ),
              if (_profilePhoto != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Remove Profile Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _removeProfilePhoto();
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('User tidak ditemukan'),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7FFF5),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF58CC02),
              ),
            ),
          );
        }

        final data = snapshot.data?.data() ?? {};

        final fullName =
            data['fullName'] ?? user.displayName ?? 'User';
        final username = data['username'] ?? '';
        final email = data['email'] ?? user.email ?? '-';
        final xp = data['xp'] ?? 0;
        final completedLessons = data['completedLessons'] ?? 0;
        final learningStreak = data['learningStreak'] ?? 0;

        return Scaffold(
          backgroundColor: const Color(0xFFF7FFF5),
          appBar: AppBar(
            title: const Text(
              'My Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFF7FFF5),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfilePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Photo
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFDFF5DF),
                      backgroundImage: _profilePhoto != null
                          ? FileImage(_profilePhoto!)
                          : null,
                      child: _isLoadingPhoto
                          ? const CircularProgressIndicator(
                              color: Color(0xFF58CC02),
                            )
                          : _profilePhoto == null
                              ? const Icon(
                                  Icons.person,
                                  size: 65,
                                  color: Color(0xFF58CC02),
                                )
                              : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        color: const Color(0xFF58CC02),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _showPhotoOptions,
                          child: const Padding(
                            padding: EdgeInsets.all(9),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Nama pengguna
                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (username.isNotEmpty)
                  Text(
                    '@$username',
                    style: const TextStyle(
                      color: Color(0xFF58CC02),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                Text(
                  email,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 24),

                // Total XP
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.bolt,
                      color: Color(0xFFFFB300),
                      size: 35,
                    ),
                    title: const Text('Total XP'),
                    subtitle: Text('$xp Experience Points'),
                  ),
                ),

                const SizedBox(height: 16),

                // Learning Statistics
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Learning Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.book,
                          color: Colors.green,
                        ),
                        title: const Text('Completed Lessons'),
                        trailing: Text('$completedLessons'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                        title: const Text('Learning Streak'),
                        trailing: Text('$learningStreak Days'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Account Settings
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.edit,
                          color: Color(0xFF58CC02),
                        ),
                        title: const Text('Edit Profile'),
                        subtitle: const Text(
                          'Change your name and username',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfilePage(),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(
                          Icons.lock_reset,
                          color: Color(0xFF58CC02),
                        ),
                        title: const Text('Change Password'),
                        subtitle: const Text(
                          'Update your account password',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ChangePasswordPage(),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Log Out',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () => logout(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
