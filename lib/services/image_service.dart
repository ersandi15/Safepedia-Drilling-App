import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickAndCompressImage(ImageSource source) async {
    // 1. Ambil gambar dari Kamera atau Galeri
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;

    File file = File(pickedFile.path);
    int fileSize = await file.length();

    // Target dalam bytes (1 KB = 1024 bytes)
    // Target aman untuk dapat bonus: ~240 KB (245760 bytes)
    int targetMaxBytes = 250 * 1024; 
    int targetMinBytes = 225 * 1024;

    // Jika ukuran sudah sesuai batas bonus, langsung kembalikan
    if (fileSize <= targetMaxBytes && fileSize >= targetMinBytes) {
      return file; 
    }

    // 2. Proses Kompresi
    int quality = 95;
    File? compressedFile = file;
    
    // Siapkan path sementara untuk file hasil kompresi
    Directory tempDir = await getTemporaryDirectory();
    String targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Looping kompresi: Jika gambar lebih besar dari 250KB, turunkan kualitasnya
    while (fileSize > targetMaxBytes && quality > 5) {
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );

      if (result != null) {
        compressedFile = File(result.path);
        fileSize = await compressedFile.length();
        quality -= 10; // Turunkan kualitas 10% untuk iterasi berikutnya jika masih kebesaran
      } else {
        break;
      }
    }

    return compressedFile;
  }
}