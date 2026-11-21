import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Semua kolom wajib diisi');
      return;
    }

    if (newPassword.length < 6) {
      showMessage('Password baru minimal 6 karakter');
      return;
    }

    if (newPassword != confirmPassword) {
      showMessage('Konfirmasi password tidak cocok');
      return;
    }

    if (currentPassword == newPassword) {
      showMessage('Password baru harus berbeda dari password lama');
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        showMessage('Pengguna tidak ditemukan');
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Gagal mengubah password';

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'Password lama tidak sesuai';
      } else if (e.code == 'weak-password') {
        message = 'Password baru terlalu lemah';
      } else if (e.code == 'requires-recent-login') {
        message = 'Silakan login ulang sebelum mengubah password';
      } else if (e.code == 'network-request-failed') {
        message = 'Periksa koneksi internet kamu';
      }

      showMessage(message);
    } catch (e) {
      showMessage('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget passwordField({
    required String label,
    required TextEditingController controller,
    required bool isHidden,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            isHidden ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FFF5),
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7FFF5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.lock_reset,
                size: 85,
                color: Color(0xFF58CC02),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Update Your Password',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Create a new password for your account',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 32),

            passwordField(
              label: 'Current Password',
              controller: currentPasswordController,
              isHidden: hideCurrentPassword,
              toggleVisibility: () {
                setState(() {
                  hideCurrentPassword = !hideCurrentPassword;
                });
              },
            ),

            const SizedBox(height: 20),

            passwordField(
              label: 'New Password',
              controller: newPasswordController,
              isHidden: hideNewPassword,
              toggleVisibility: () {
                setState(() {
                  hideNewPassword = !hideNewPassword;
                });
              },
            ),

            const SizedBox(height: 20),

            passwordField(
              label: 'Confirm New Password',
              controller: confirmPasswordController,
              isHidden: hideConfirmPassword,
              toggleVisibility: () {
                setState(() {
                  hideConfirmPassword = !hideConfirmPassword;
                });
              },
            ),

            const SizedBox(height: 12),

            const Text(
              'Password baru harus memiliki minimal 6 karakter.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58CC02),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'UPDATE PASSWORD',
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
