import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_card.dart';

/// Elevated section card used across the invoice creation flow.
class InvoiceSectionCard extends StatelessWidget {
  const InvoiceSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
  });

  final String title;
  final Widget child;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.space2),
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCardHeader(title: title, icon: icon, trailing: trailing),
          const SizedBox(height: AppDimensions.space2),
          child,
        ],
      ),
    );
  }
}

/// Grand total label + amount row with horizontal scroll for long values.
class InvoiceGrandTotalRow extends StatelessWidget {
  const InvoiceGrandTotalRow({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Grand Total', style: context.sectionTitleStyle),
        ),
        const SizedBox(width: AppDimensions.space1),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            child: AnimatedCurrencyText(
              amount: amount,
              formatter: CurrencyFormatter.format,
              highlight: true,
              style: AppTypography.heading(AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated currency display for live total updates.
class AnimatedCurrencyText extends StatelessWidget {
  const AnimatedCurrencyText({
    super.key,
    required this.amount,
    required this.formatter,
    this.style,
    this.highlight = false,
  });

  final double amount;
  final String Function(double) formatter;
  final TextStyle? style;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? AppTypography.bodyMedium(AppColors.textPrimary);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        formatter(amount),
        key: ValueKey(amount.toStringAsFixed(2)),
        textAlign: TextAlign.end,
        style: highlight
            ? baseStyle.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)
            : baseStyle.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Pill chip for selectable payment options.
class InvoiceChoiceChip extends StatelessWidget {
  const InvoiceChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.elementGap),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppDimensions.iconSizeSm,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimensions.elementGapSm),
            ],
            Text(
              label,
              style: AppTypography.caption(
                selected ? AppColors.primary : AppColors.textSecondary,
              ).copyWith(fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stable numeric input for summary and payment fields.
class InvoiceNumericField extends StatefulWidget {
  const InvoiceNumericField({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 110,
    this.textStyle,
    this.prefixText,
    this.hint = '0',
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double width;
  final TextStyle? textStyle;
  final String? prefixText;
  final String hint;

  @override
  State<InvoiceNumericField> createState() => _InvoiceNumericFieldState();
}

class _InvoiceNumericFieldState extends State<InvoiceNumericField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _displayText(widget.value));
  }

  @override
  void didUpdateWidget(InvoiceNumericField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final display = _displayText(widget.value);
      if (_controller.text != display) _controller.text = display;
    }
  }

  String _displayText(double value) =>
      value == 0 ? '' : value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.right,
      style: widget.textStyle ?? AppTypography.caption(AppColors.textPrimary),
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hint,
        prefixText: widget.prefixText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.elementGap,
          vertical: AppDimensions.elementGapSm,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      onChanged: (v) => widget.onChanged(double.tryParse(v) ?? 0),
    );

    if (widget.width == double.infinity) {
      return SizedBox(height: AppDimensions.inputHeight, child: field);
    }

    return SizedBox(width: widget.width, height: AppDimensions.inputHeight, child: field);
  }
}
