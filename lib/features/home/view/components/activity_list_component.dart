import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../config/app_colors.dart';
import '../../models/drilling_activity_model.dart';

class ActivityListComponent extends StatelessWidget {
  final List<DrillingActivityModel> list;
  final bool isDraft;

  const ActivityListComponent({
    super.key,
    required this.list,
    required this.isDraft,
  });

  @override
  Widget build(BuildContext context) {
    // Jika list kosong, kembalikan tampilan kosong (Empty State)
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDraft ? Icons.inbox : Icons.cloud_done_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isDraft ? 'Belum ada data Draft' : 'Belum ada data Submitted',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Jika ada data, buat list berupa Card
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            // Tampilkan thumbnail gambar di sebelah kiri
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(item.imagePath),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                // Handle error jika gambar fisik terhapus dari galeri
                errorBuilder: (_, _, _) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            title: Text(
              'Hole ID: ${item.holeId}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Date: ${item.date}'),
                Text(
                  'Status: ${item.status}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDraft
                    ? AppColors.statusDraft.withValues(alpha: 0.1)
                    : AppColors.statusSubmitted.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDraft
                      ? AppColors.statusDraft
                      : AppColors.statusSubmitted,
                ),
              ),
              child: Text(
                isDraft ? 'Draft' : 'Submitted',
                style: TextStyle(
                  color: isDraft
                      ? AppColors.statusDraft
                      : AppColors.statusSubmitted,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
