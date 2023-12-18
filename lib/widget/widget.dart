import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionChoiceChipWidget extends StatelessWidget {
  const TransactionChoiceChipWidget({
    super.key,
    required this.choiceName,
    required this.selected,
    this.onselected,
  });
  final String choiceName;
  final bool selected;
  final void Function(bool)? onselected;
  @override
  Widget build(BuildContext context) {
    return ChoiceChip.elevated(
      padding: const EdgeInsets.all(7),
      label: Text(
        choiceName,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF1EDEC7),
            fontSize: 15),
      ),
      selectedColor: const Color(0xFF1EDEC7),
      onSelected: onselected,
      selected: selected,
      disabledColor: Colors.grey.shade300,
    );
  }
}
