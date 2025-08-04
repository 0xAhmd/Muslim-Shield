import 'package:azkar/constants.dart';
import 'package:azkar/home/data/models/surah.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReciterSelectionDialog extends StatefulWidget {
  final List<Reciter> reciters;
  final int selectedReciterId;
  final Function(Reciter) onReciterSelected;

  const ReciterSelectionDialog({
    super.key,
    required this.reciters,
    required this.selectedReciterId,
    required this.onReciterSelected,
  });

  @override
  State<ReciterSelectionDialog> createState() => _ReciterSelectionDialogState();
}

class _ReciterSelectionDialogState extends State<ReciterSelectionDialog> {
  late int selectedId;
  String searchQuery = '';
  List<Reciter> filteredReciters = [];

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedReciterId;
    filteredReciters = widget.reciters;
  }

  void _filterReciters(String query) {
    setState(() {
      searchQuery = query.toLowerCase().trim();
      if (searchQuery.isEmpty) {
        filteredReciters = widget.reciters;
      } else {
        filteredReciters = widget.reciters.where((reciter) {
          return reciter.name.toLowerCase().contains(searchQuery) ||
              reciter.style.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: gray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.record_voice_over, color: primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select Reciter',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Field
            TextField(
              onChanged: _filterReciters,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search reciters...',
                hintStyle: GoogleFonts.poppins(color: textColor),
                prefixIcon: Icon(Icons.search, color: textColor),
                filled: true,
                fillColor: background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results count
            if (searchQuery.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${filteredReciters.length} reciter${filteredReciters.length == 1 ? '' : 's'} found',
                  style: GoogleFonts.poppins(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Reciters List
            Expanded(
              child: filteredReciters.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: textColor),
                          const SizedBox(height: 12),
                          Text(
                            'No reciters found',
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredReciters.length,
                      itemBuilder: (context, index) {
                        final reciter = filteredReciters[index];
                        final isSelected = reciter.id == selectedId;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primary.withOpacity(0.1)
                                : background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? primary : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                selectedId = reciter.id;
                              });
                            },
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primary
                                    : textColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.person,
                                color: isSelected ? Colors.white : textColor,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              reciter.name,
                              style: GoogleFonts.poppins(
                                color: isSelected ? primary : Colors.white,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              reciter.style,
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 12,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: primary)
                                : null,
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final selectedReciter = filteredReciters.firstWhere(
                        (r) => r.id == selectedId,
                        orElse: () => widget.reciters.first,
                      );
                      widget.onReciterSelected(selectedReciter);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Select',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
