import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safepedia_drilling_app/config/app_fonts.dart';
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
    if (list.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(), // Memberikan efek bounce ala iOS
      padding: const EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: 100, // Ruang untuk FAB
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildCard(list[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Membuat lingkaran dengan efek glow/soft
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDraft
                    ? AppColors.statusDraft.withValues(alpha: 0.05)
                    : AppColors.statusSubmitted.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDraft
                      ? AppColors.statusDraft.withValues(alpha: 0.2)
                      : AppColors.statusSubmitted.withValues(alpha: 0.2),
                  width: 2,
                  // Trik visual agar tidak terlalu solid
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: Center(
                child: Icon(
                  isDraft ? Icons.edit_document : Icons.cloud_done_rounded,
                  size: 50,
                  color: isDraft
                      ? AppColors.statusDraft.withValues(alpha: 0.8)
                      : AppColors.statusSubmitted.withValues(alpha: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isDraft ? 'Belum ada Draft' : 'Belum ada Data Terkirim',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol + di bawah untuk\nmerekam aktivitas drilling baru.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(DrillingActivityModel item) {
    final isComplete = item.status == 'Complete';

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Margin diperbesar sedikit
      padding: const EdgeInsets.all(
        12,
      ), // Menggunakan padding seragam di dalam card
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Gambar Thumbnail (kiri) ──
          ClipRRect(
            borderRadius: BorderRadius.circular(
              12,
            ), // Radius melingkar di semua sisi
            child: Image.file(
              File(item.imagePath),
              width: 85,
              height: 85, // Dibuat kotak presisi
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 85,
                height: 85,
                color: AppColors.background,
                child: const Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16), // Jarak antara gambar dan teks
          // ── Konten Informasi (kanan) ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Baris 1: Hole ID + Badge Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.holeId,
                        style:
                            AppFonts.heading3, // Menggunakan font dari config
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(),
                  ],
                ),
                const SizedBox(height: 10), // Spasi diperbesar agar bernapas
                // Baris 2: Tanggal
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      size: 16, // Ukuran icon disesuaikan
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.date,
                      style: AppFonts.caption, // Menggunakan font caption
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Baris 3: Status Pengerjaan
                Row(
                  children: [
                    Icon(
                      isComplete
                          ? Icons.check_circle_rounded
                          : Icons.pending_actions_rounded,
                      size: 16, // Ukuran icon disesuaikan
                      color: isComplete
                          ? AppColors.statusSubmitted
                          : AppColors.statusDraft,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.status,
                      style: AppFonts.bodyMedium.copyWith(
                        // Override warna
                        color: isComplete
                            ? AppColors.statusSubmitted
                            : AppColors.statusDraft,
                        fontWeight: FontWeight
                            .w700, // Dibuat lebih tebal dari teks tanggal
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ), // Padding diperbesar sedikit
      decoration: BoxDecoration(
        color: isDraft
            ? AppColors.statusDraft.withValues(alpha: 0.12)
            : AppColors.statusSubmitted.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8), // Sudut agak tegas
      ),
      child: Text(
        isDraft ? 'DRAFT' : 'SUBMITTED',
        style: AppFonts.badge.copyWith(
          color: isDraft ? AppColors.statusDraft : AppColors.statusSubmitted,
        ),
      ),
    );
  }
}
