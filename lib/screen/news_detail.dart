import 'package:flutter/material.dart';
import 'package:uts_abil/model/news.dart';
import 'package:uts_abil/screen/edit.dart';
import 'package:uts_abil/screen/home.dart';
import 'package:uts_abil/service/appwrite.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Berita',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            if (news.imageId != null)
              Image.network(
                news.imageId ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image, size: 100)),
              ),

            const SizedBox(height: 16),

            // Title and Date
            Text(
              news.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  news.date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Content
            Text(
              news.content,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
