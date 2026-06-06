import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safepedia_drilling_app/config/app_fonts.dart';
import '../../../../config/app_colors.dart';
import '../../models/drilling_activity_model.dart';

class ActivityListComponent extends StatelessWidget {
  final List<DrillingActivityModel> list;
  final bool isDraft;

  /// Callback dipanggil saat card Draft di-tap untuk edit.
  /// Hanya digunakan ketika [isDraft] = true.
  final void Function(DrillingActivityModel)? onEdit;

  const ActivityListComponent({
    super.key,
    required this.list,
    required this.isDraft,
    this.onEdit,
  });

  // Breakpoint: lebar >= 600 dianggap tablet
  static const double _tabletBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= _tabletBreakpoint;

        if (isTablet) {
          // ── Tablet: Grid 2 kolom ──
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.04,
              vertical: 20,
            ).copyWith(bottom: 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.6,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildCardWrapper(list[index]);
            },
          );
        }

        // ── Phone: Single column ──
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: 100,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _buildCardWrapper(list[index]);
          },
        );
      },
    );
  }

  /// Membungkus card dengan InkWell tap (untuk draft) atau plain card
  Widget _buildCardWrapper(DrillingActivityModel item) {
    if (isDraft && onEdit != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onEdit!(item),
          child: _buildCard(item),
        ),
      );
    }
    return _buildCard(item);
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
          ),
        );
      },
    );
  }

  Widget _buildCard(DrillingActivityModel item) {
    final isComplete = item.status == 'Complete';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Gambar Thumbnail ──
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(item.imagePath),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ── Konten Informasi ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Baris 1: Hole ID + Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          item.holeId,
                          style: AppFonts.heading3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Baris 2: Tanggal
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          item.date,
                          style: AppFonts.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Baris 3: Status + Edit hint (hanya draft)
                  Row(
                    children: [
                      Icon(
                        isComplete
                            ? Icons.check_circle_rounded
                            : Icons.pending_actions_rounded,
                        size: 14,
                        color: isComplete
                            ? AppColors.statusSubmitted
                            : AppColors.statusDraft,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          item.status,
                          style: AppFonts.bodyMedium.copyWith(
                            color: isComplete
                                ? AppColors.statusSubmitted
                                : AppColors.statusDraft,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // Edit hint khusus draft
                      if (isDraft)
                        Icon(
                          Icons.edit_rounded,
                          size: 15,
                          color: AppColors.primary.withValues(alpha: 0.45),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDraft
            ? AppColors.statusDraft.withValues(alpha: 0.12)
            : AppColors.statusSubmitted.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
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
