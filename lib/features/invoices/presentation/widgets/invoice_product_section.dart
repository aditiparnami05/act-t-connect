import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/product.dart';
import '../models/create_invoice_draft.dart';
import 'invoice_product_line_card.dart';
import 'invoice_section_card.dart';
import 'invoice_shared_widgets.dart';

class InvoiceProductSection extends StatelessWidget {
  const InvoiceProductSection({
    super.key,
    required this.lines,
    required this.onAddProduct,
    required this.onSearch,
    required this.onScanBarcode,
    required this.onEditLine,
    required this.onDeleteLine,
  });

  final List<InvoiceLineDraft> lines;
  final VoidCallback onAddProduct;
  final VoidCallback onSearch;
  final VoidCallback onScanBarcode;
  final void Function(int index) onEditLine;
  final void Function(int index) onDeleteLine;

  @override
  Widget build(BuildContext context) {
    return InvoiceSectionCard(
      title: 'Products',
      icon: Symbols.shopping_cart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSearch,
                  icon: const Icon(Symbols.search, size: 20),
                  label: const Text('Search'),
                ),
              ),
              const SizedBox(width: AppDimensions.elementGap),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onScanBarcode,
                  icon: const Icon(Symbols.barcode_scanner, size: 20),
                  label: const Text('Scan'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space2),
          if (lines.isEmpty)
            InvoiceEmptyState(
              icon: Symbols.package_2,
              message: 'Add products to your invoice',
              actionLabel: 'Browse Products',
              onAction: onAddProduct,
            )
          else
            ...List.generate(lines.length, (i) {
              return InvoiceProductLineCard(
                line: lines[i],
                onEdit: () => onEditLine(i),
                onDelete: () => onDeleteLine(i),
              );
            }),
          const SizedBox(height: AppDimensions.elementGap),
          SizedBox(
            height: AppDimensions.buttonHeight,
            child: FilledButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Symbols.add_circle, size: 22),
              label: Text('Add Product', style: AppTypography.bodyMedium(Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for product search and selection.
class ProductPickerSheet extends StatefulWidget {
  const ProductPickerSheet({super.key, required this.products});

  final List<Product> products;

  @override
  State<ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<ProductPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filtered {
    if (_query.isEmpty) return widget.products;
    final q = _query.toLowerCase();
    return widget.products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.sku.toLowerCase().contains(q) ||
          (p.barcode?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) => Container(
        decoration: invoiceSheetDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InvoiceSheetHandle(),
            const InvoiceSheetTitle('Select Product'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.cardPaddingLg),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Search by name, HSN or barcode...',
                  prefixIcon: Icon(Symbols.search),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.elementGap),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.elementGap),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final p = _filtered[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.elementGap,
                      vertical: AppDimensions.elementGapSm,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Symbols.inventory_2, color: AppColors.primary, size: 20),
                    ),
                    title: Text(p.name, style: context.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: Text('HSN ${p.sku} • Stock: ${p.stock} ${p.unit}', style: context.captionStyle),
                    trailing: Text(
                      '₹${p.sellingPrice.toStringAsFixed(0)}',
                      style: AppTypography.bodyMedium(AppColors.primary).copyWith(fontWeight: FontWeight.w700),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    onTap: () => Navigator.pop(context, p),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog for editing a line item.
class EditLineItemDialog extends StatefulWidget {
  const EditLineItemDialog({super.key, required this.line});

  final InvoiceLineDraft line;

  @override
  State<EditLineItemDialog> createState() => _EditLineItemDialogState();
}

class _EditLineItemDialogState extends State<EditLineItemDialog> {
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: '${widget.line.quantity}');
    _priceController = TextEditingController(text: widget.line.rate.toString());
    _discountController = TextEditingController(text: widget.line.discount.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radius)),
      title: Text('Edit ${widget.line.product.name}', style: context.sectionTitleStyle),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            const SizedBox(height: AppDimensions.elementGap),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: AppDimensions.elementGap),
            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Discount %'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, {
              'quantity': int.tryParse(_qtyController.text) ?? widget.line.quantity,
              'price': double.tryParse(_priceController.text) ?? widget.line.rate,
              'discount': double.tryParse(_discountController.text) ?? widget.line.discount,
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
