import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePhotoService {
  final ImagePicker _picker = ImagePicker();

  String _photoPathKey(String uid) => 'profile_photo_path_$uid';

  // Memilih foto dari galeri
  Future<File?> pickPhoto(String uid) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) {
      return null;
    }

    return savePhoto(File(pickedFile.path), uid);
  }

  // Menyimpan foto berdasarkan UID pengguna
  Future<File> savePhoto(File imageFile, String uid) async {
    final directory = await getApplicationDocumentsDirectory();

    final savedFile = await imageFile.copy(
      '${directory.path}/profile_photo_$uid.jpg',
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _photoPathKey(uid),
      savedFile.path,
    );

    return savedFile;
  }

  // Mengambil foto berdasarkan UID pengguna
  Future<File?> loadPhoto(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    final path = prefs.getString(_photoPathKey(uid));

    if (path == null) {
      return null;
    }

    final file = File(path);

    if (await file.exists()) {
      return file;
    }

    return null;
  }

  // Menghapus foto berdasarkan UID pengguna
  Future<void> removePhoto(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    final path = prefs.getString(_photoPathKey(uid));

    if (path != null) {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    }

    await prefs.remove(_photoPathKey(uid));
  }
}
