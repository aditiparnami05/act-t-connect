import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import 'invoice_section_card.dart';

class InvoiceAttachmentsSection extends StatelessWidget {
  const InvoiceAttachmentsSection({
    super.key,
    required this.attachments,
    required this.onCamera,
    required this.onGallery,
    required this.onDocument,
    required this.onRemove,
  });

  final List<String> attachments;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onDocument;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return InvoiceSectionCard(
      title: 'Attachments',
      icon: Symbols.attach_file,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _AttachButton(label: 'Camera', icon: Symbols.photo_camera, onTap: onCamera)),
                const SizedBox(width: AppDimensions.elementGap),
                Expanded(child: _AttachButton(label: 'Gallery', icon: Symbols.photo_library, onTap: onGallery)),
                const SizedBox(width: AppDimensions.elementGap),
                Expanded(child: _AttachButton(label: 'Documents', icon: Symbols.description, onTap: onDocument)),
              ],
            ),
          ),
          if (attachments.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.space2),
            Text('Uploaded Files', style: AppTypography.label(AppColors.textPrimary)),
            const SizedBox(height: AppDimensions.elementGapSm),
            ...List.generate(attachments.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.elementGapSm),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.cardPadding,
                  vertical: AppDimensions.elementGap,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Symbols.insert_drive_file, color: AppColors.primary, size: 20),
                    const SizedBox(width: AppDimensions.elementGap),
                    Expanded(
                      child: Text(attachments[i], style: context.captionStyle),
                    ),
                    IconButton(
                      onPressed: () => onRemove(i),
                      icon: const Icon(Symbols.close, size: 18),
                      color: AppColors.error,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  const _AttachButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: AppDimensions.iconSize),
              const SizedBox(height: AppDimensions.elementGapSm),
              Text(
                label,
                style: AppTypography.label(AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
