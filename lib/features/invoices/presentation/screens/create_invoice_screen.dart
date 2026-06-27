import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/models/party.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/providers/data_providers.dart';
import '../models/create_invoice_draft.dart';
import '../providers/create_invoice_provider.dart';
import '../widgets/invoice_attachments_section.dart';
import '../widgets/invoice_bottom_action_bar.dart';
import '../widgets/invoice_create_header.dart';
import '../widgets/invoice_customer_card.dart';
import '../widgets/invoice_notes_section.dart';
import '../widgets/invoice_payment_section.dart';
import '../widgets/invoice_product_section.dart';
import '../widgets/invoice_shared_widgets.dart';
import '../widgets/invoice_summary_card.dart';

/// Premium invoice creation screen with full ERP-style workflow.
class CreateInvoiceScreen extends ConsumerStatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  ConsumerState<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends ConsumerState<CreateInvoiceScreen> {
  final _specialNotesController = TextEditingController();
  final _termsController = TextEditingController();
  final _remarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _specialNotesController.dispose();
    _termsController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  CreateInvoiceNotifier get _notifier =>
      ref.read(createInvoiceProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(createInvoiceProvider);
    final isTablet = context.isTablet;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InvoiceCreateHeader(
              onBack: () => context.pop(),
              onShare: () => _showActionSnack('Invoice shared'),
              onPreview: _previewPdf,
              onMore: _showMoreOptions,
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _onRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.only(bottom: AppDimensions.space2 + keyboardInset),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppDimensions.maxContentWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InvoiceMetaStrip(
                              draft: draft,
                              onInvoiceDateTap: () => _pickDate(
                                draft.invoiceDate,
                                _notifier.setInvoiceDate,
                              ),
                              onDueDateTap: () => _pickDate(
                                draft.dueDate,
                                _notifier.setDueDate,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.screenPaddingH,
                              ),
                              child: isTablet
                                  ? _buildTabletLayout(draft)
                                  : _buildPhoneLayout(draft),
                            ),
                            InvoiceBottomActionBar(
                              grandTotal: draft.grandTotal,
                              canGenerate: draft.isValid,
                              onSaveDraft: _saveDraft,
                              onPreviewPdf: _previewPdf,
                              onGenerate: _generateInvoice,
                              onPrint: () => _showActionSnack('Sending to printer...'),
                              onSharePdf: () => _showActionSnack('PDF shared'),
                            ),
                            SizedBox(height: MediaQuery.paddingOf(context).bottom),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneLayout(CreateInvoiceDraft draft) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildSections(draft),
    );
  }

  Widget _buildTabletLayout(CreateInvoiceDraft draft) {
    final sections = _buildSections(draft);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: sections[0]),
            const SizedBox(width: AppDimensions.space2),
            Expanded(child: sections[1]),
          ],
        ),
        sections[2],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: sections[3]),
            const SizedBox(width: AppDimensions.space2),
            Expanded(child: sections[4]),
          ],
        ),
        sections[5],
      ],
    );
  }

  List<Widget> _buildSections(CreateInvoiceDraft draft) {
    return [
      InvoiceCustomerCard(
        customer: draft.customer,
        onSelectCustomer: _selectCustomer,
      ),
      InvoiceProductSection(
        lines: draft.lines,
        onAddProduct: _addProduct,
        onSearch: _addProduct,
        onScanBarcode: _scanBarcode,
        onEditLine: _editLine,
        onDeleteLine: _deleteLine,
      ),
      InvoiceSummaryCard(
        draft: draft,
        onShippingChanged: _notifier.setShipping,
        onRoundOffChanged: _notifier.setRoundOff,
      ),
      InvoicePaymentSection(
        draft: draft,
        onMethodChanged: _notifier.setPaymentMethod,
        onStatusChanged: _notifier.setPaymentStatus,
        onAmountReceivedChanged: _notifier.setAmountReceived,
      ),
      InvoiceNotesSection(
        specialNotesController: _specialNotesController,
        termsController: _termsController,
        remarksController: _remarksController,
      ),
      InvoiceAttachmentsSection(
        attachments: draft.attachments,
        onCamera: () => _addAttachment('Camera photo'),
        onGallery: () => _addAttachment('Gallery image'),
        onDocument: () => _addAttachment('Document.pdf'),
        onRemove: _notifier.removeAttachment,
      ),
    ];
  }

  Future<void> _onRefresh() async {
    final invoices = await ref.refresh(invoicesProvider.future);
    _notifier.refreshInvoiceNumber(invoices.length);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice refreshed')),
      );
    }
  }

  Future<void> _pickDate(DateTime initial, ValueChanged<DateTime> onSelected) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) onSelected(picked);
  }

  Future<void> _selectCustomer() async {
    final customers = await ref.read(customersProvider.future);
    if (!mounted) return;

    final selected = await showModalBottomSheet<Party>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CustomerPickerSheet(customers: customers),
    );

    if (selected != null) _notifier.setCustomer(selected);
  }

  Future<void> _addProduct() async {
    final products = await ref.read(productsProvider.future);
    if (!mounted) return;

    final selected = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProductPickerSheet(products: products),
    );

    if (selected != null) _notifier.addProduct(selected);
  }

  void _scanBarcode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Barcode scanner ready — point camera at product'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _editLine(int index) async {
    final draft = ref.read(createInvoiceProvider);
    final line = draft.lines[index];

    final result = await showDialog<Map<String, num>>(
      context: context,
      builder: (_) => EditLineItemDialog(line: line),
    );

    if (result != null) {
      _notifier.updateLine(
        line.id,
        line.copyWith(
          quantity: result['quantity']!.toInt(),
          customRate: result['price']!.toDouble(),
          discount: result['discount']!.toDouble(),
        ),
      );
    }
  }

  void _deleteLine(int index) {
    final line = ref.read(createInvoiceProvider).lines[index];
    _notifier.removeLine(line.id);
  }

  void _addAttachment(String label) {
    _notifier.addAttachment('$label ${DateTime.now().millisecond}');
    _showActionSnack('Attachment added');
  }

  void _saveDraft() {
    _syncNotesToProvider();
    _notifier.saveDraft();
    _showActionSnack('Draft saved', success: true);
  }

  void _previewPdf() {
    _showActionSnack('PDF preview generated');
  }

  void _generateInvoice() {
    final draft = ref.read(createInvoiceProvider);
    if (!draft.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a customer and add at least one product'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    _syncNotesToProvider();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice ${draft.invoiceNumber} created for ${draft.customer!.name}'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  void _syncNotesToProvider() {
    _notifier
      ..setSpecialNotes(_specialNotesController.text)
      ..setTerms(_termsController.text)
      ..setCustomerRemarks(_remarksController.text);
  }

  void _showActionSnack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? AppColors.success : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Symbols.content_copy),
              title: const Text('Duplicate Invoice'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Symbols.delete_outline, color: AppColors.error),
              title: const Text('Clear Form', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                _notifier.reset();
                _specialNotesController.clear();
                _termsController.clear();
                _remarksController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerPickerSheet extends StatefulWidget {
  const _CustomerPickerSheet({required this.customers});

  final List<Party> customers;

  @override
  State<_CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<_CustomerPickerSheet> {
  String _query = '';

  List<Party> get _filtered {
    if (_query.isEmpty) return widget.customers;
    final q = _query.toLowerCase();
    return widget.customers
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.phone.contains(q) ||
            (c.gstin?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      builder: (_, controller) => Container(
        decoration: invoiceSheetDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InvoiceSheetHandle(),
            const InvoiceSheetTitle('Select Customer'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.cardPaddingLg),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Search customers...',
                  prefixIcon: Icon(Symbols.search),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.elementGap),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.elementGap),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final c = _filtered[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.elementGap,
                      vertical: AppDimensions.elementGapSm,
                    ),
                    leading: Hero(
                      tag: 'invoice-customer-${c.id}',
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                        child: Text(
                          c.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${c.phone}${c.gstin != null ? ' • GST ${c.gstin}' : ''}'),
                    onTap: () => Navigator.pop(context, c),
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
