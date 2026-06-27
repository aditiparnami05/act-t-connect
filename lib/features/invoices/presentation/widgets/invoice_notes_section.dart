import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_dimensions.dart';
import 'invoice_section_card.dart';
import 'invoice_shared_widgets.dart';

class InvoiceNotesSection extends StatelessWidget {
  const InvoiceNotesSection({
    super.key,
    required this.specialNotesController,
    required this.termsController,
    required this.remarksController,
  });

  final TextEditingController specialNotesController;
  final TextEditingController termsController;
  final TextEditingController remarksController;

  @override
  Widget build(BuildContext context) {
    return InvoiceSectionCard(
      title: 'Notes',
      icon: Symbols.notes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InvoiceFormField(
            label: 'Special Notes',
            hint: 'Add any special instructions...',
            controller: specialNotesController,
            icon: Symbols.sticky_note_2,
          ),
          const SizedBox(height: AppDimensions.space2),
          InvoiceFormField(
            label: 'Terms & Conditions',
            hint: 'Payment terms, delivery terms...',
            controller: termsController,
            icon: Symbols.gavel,
            maxLines: 3,
          ),
          const SizedBox(height: AppDimensions.space2),
          InvoiceFormField(
            label: 'Customer Remarks',
            hint: 'Notes from customer...',
            controller: remarksController,
            icon: Symbols.chat,
          ),
        ],
      ),
    );
  }
}
