import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:uts_abil/model/news.dart';
import 'package:uts_abil/model/user.dart';
import 'package:uts_abil/screen/home.dart';
import 'package:uts_abil/screen/login.dart';

class AppwriteService {
  Client client = Client();
  late Account account;
  late Databases databases;
  late Storage storage;

  AppwriteService() {
    client
      ..setEndpoint(
          'https://cloud.appwrite.io/v1') // Ganti dengan endpoint Appwrite Anda
      ..setProject("pmlabil77"); // Ganti dengan project ID Appwrite Anda

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
  }

  // Fungsi untuk mendaftarkan pengguna baru
  Future<UserModel?> register(
      String email, String password, String name) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return UserModel(
        id: user.$id,
        name: user.name,
        email: user.email,
      );
    } on AppwriteException catch (e) {
      print(" gagal : $e");
      if (e.code == 409) {
        throw 'Email sudah digunakan, silahkan gunakan email lain';
      }
      throw 'Terjadi kesalahan saat register';
    }
  }

  // Fungsi untuk login pengguna
  Future<void> login(String email, String password, context) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      print('Login successful');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } on AppwriteException catch (e) {
      print(e);
      if (e.code == 401) {
        throw 'Email dan password salah';
      }
      throw 'Terjadi kesalahan saat login, pastikan internet anda terhubung';
    }
  }

  // Logout pengguna
  Future<void> logout(context) async {
    try {
      await account.deleteSession(sessionId: 'current');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    } catch (e) {
      throw Exception('Gagal logout');
    }
  }

  // Mendapatkan detail pengguna saat ini
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await account.get();
      return UserModel(
        id: user.$id,
        name: user.name,
        email: user.email,
      );
    } catch (e) {
      throw Exception('Gagal mengambil data pengguna saat ini');
    }
  }

  // Mengambil berita dari database
  Future<List<News>> fetchNews() async {
    try {
      final response = await databases.listDocuments(
        databaseId: '6770bedc00181e3bf118',
        collectionId: '6770bee5000d829a539f',
        queries: [
          Query.orderDesc(
              '\$createdAt'), // Mengurutkan berdasarkan kolom createdAt secara descending
        ],
      );
      return response.documents.map((doc) => News.fromMap(doc.data)).toList();
    } on AppwriteException catch (e) {
      print("Error fetching news: ${e.message}");
      return [];
    } catch (e) {
      print("Unexpected error: $e");
      return [];
    }
  }

  // Menambahkan berita baru dengan gambar
  Future<void> createNews(String title, String content, String date,
      {String? imagePath}) async {
    try {
      String? imageUrl;
      String? bucketId;

      if (imagePath != null) {
        final responseImg = await storage.createFile(
          bucketId: '6770ce9d0034334b87ca', // Ganti dengan bucket ID Anda
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: imagePath,
            filename: imagePath.split('/').last,
          ),
        );
        imageUrl =
            'https://cloud.appwrite.io/v1/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=pmlabil77&mode=admin';
        bucketId = responseImg.$id;
      }

      Map<String, dynamic> data = {
        'title': title,
        'content': content,
        'date': date,
      };

      if (imageUrl != null) {
        data['imageId'] = imageUrl;
        data['bucketId'] = bucketId;
      }

      await databases.createDocument(
        databaseId: '6770bedc00181e3bf118',
        collectionId: '6770bee5000d829a539f',
        documentId: ID.unique(),
        data: data,
      );
      print("News created successfully");
    } on AppwriteException catch (e) {
      print("Error creating news: ${e.message}");
      throw 'Gagal menambahkan berita';
    }
  }

  // Memperbarui berita yang ada
  Future<void> updateNews(String id, String title, String content, String date,
      {String? imagePath, String? oldBucketId}) async {
    try {
      String? imageUrl;
      String? bucketId;

      if (imagePath != null) {
        final responseImg = await storage.createFile(
          bucketId: '6770ce9d0034334b87ca', // Ganti dengan bucket ID Anda
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: imagePath,
            filename: imagePath.split('/').last,
          ),
        );
        imageUrl =
            'https://cloud.appwrite.io/v1/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=pmlabil77&mode=admin';
        bucketId = responseImg.$id;

        // Menghapus file lama jika ada
        if (oldBucketId != null) {
          await storage.deleteFile(
            bucketId: '6770ce9d0034334b87ca', // Ganti dengan bucket ID Anda
            fileId: oldBucketId,
          );
        }
      }

      Map<String, dynamic> data = {
        'title': title,
        'content': content,
        'date': date,
      };

      if (imageUrl != null) {
        data['imageId'] = imageUrl;
        data['bucketId'] = bucketId;
      }

      await databases.updateDocument(
        databaseId: '6770bedc00181e3bf118',
        collectionId: '6770bee5000d829a539f',
        documentId: id,
        data: data,
      );
      print("News updated successfully");
    } on AppwriteException catch (e) {
      print("Error updating news: ${e.message}");
      throw 'Gagal memperbarui berita';
    }
  }

  // Menghapus berita
  Future<void> deleteNews(String id) async {
    try {
      await databases.deleteDocument(
        databaseId: '6770bedc00181e3bf118',
        collectionId: '6770bee5000d829a539f',
        documentId: id,
      );
      print("News deleted successfully");
    } on AppwriteException catch (e) {
      print("Error deleting news: ${e.message}");
      throw 'Gagal menghapus berita';
    }
  }
}
