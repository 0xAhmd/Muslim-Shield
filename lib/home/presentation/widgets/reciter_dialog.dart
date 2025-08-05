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
      filteredReciters = searchQuery.isEmpty
          ? widget.reciters
          : widget.reciters.where((reciter) {
              final nameMatch = reciter.name.toLowerCase().contains(
                searchQuery,
              );
              final styleMatch =
                  reciter.style?.toLowerCase().contains(searchQuery) ?? false;
              return nameMatch || styleMatch;
            }).toList();
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
            _DialogHeader(),
            const SizedBox(height: 16),
            _SearchField(onChanged: _filterReciters),
            const SizedBox(height: 16),
            if (searchQuery.isNotEmpty)
              _ResultsCount(count: filteredReciters.length),
            const SizedBox(height: 12),
            Expanded(
              child: _RecitersList(
                reciters: filteredReciters,
                selectedId: selectedId,
                searchQuery: searchQuery,
                onSelect: (id) => setState(() => selectedId = id),
                onClearSearch: () => setState(() {
                  searchQuery = '';
                  filteredReciters = widget.reciters;
                }),
              ),
            ),
            const SizedBox(height: 16),
            _ActionButtons(
              onCancel: () => Navigator.of(context).pop(),
              onSelect: () {
                final selectedReciter = filteredReciters.firstWhere(
                  (r) => r.id == selectedId,
                  orElse: () => widget.reciters.first,
                );
                widget.onReciterSelected(selectedReciter);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
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
    );
  }
}

class _ResultsCount extends StatelessWidget {
  final int count;

  const _ResultsCount({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$count reciter${count == 1 ? '' : 's'} found',
        style: GoogleFonts.poppins(
          color: primary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _RecitersList extends StatelessWidget {
  final List<Reciter> reciters;
  final int selectedId;
  final String searchQuery;
  final ValueChanged<int> onSelect;
  final VoidCallback onClearSearch;

  const _RecitersList({
    required this.reciters,
    required this.selectedId,
    required this.searchQuery,
    required this.onSelect,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    if (reciters.isEmpty) {
      return _EmptyState(
        searchQuery: searchQuery,
        onClearSearch: onClearSearch,
      );
    }

    return ListView.builder(
      itemCount: reciters.length,
      itemBuilder: (context, index) {
        final reciter = reciters[index];
        return _ReciterTile(
          reciter: reciter,
          isSelected: reciter.id == selectedId,
          onTap: () => onSelect(reciter.id),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearSearch;

  const _EmptyState({required this.searchQuery, required this.onClearSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: textColor),
          const SizedBox(height: 12),
          Text(
            searchQuery.isEmpty
                ? 'No reciters available'
                : 'No reciters found for "$searchQuery"',
            style: GoogleFonts.poppins(color: textColor, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onClearSearch,
              child: Text(
                'Clear search',
                style: GoogleFonts.poppins(color: primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReciterTile extends StatelessWidget {
  final Reciter reciter;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReciterTile({
    required this.reciter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? primary.withOpacity(0.1) : background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: _ReciterAvatar(isSelected: isSelected),
        title: Text(
          reciter.name,
          style: GoogleFonts.poppins(
            color: isSelected ? primary : Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          reciter.style ?? 'Tajweed',
          style: GoogleFonts.poppins(color: textColor, fontSize: 12),
        ),
        trailing: _ReciterTrailing(reciter: reciter, isSelected: isSelected),
      ),
    );
  }
}

class _ReciterAvatar extends StatelessWidget {
  final bool isSelected;

  const _ReciterAvatar({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? primary : textColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.person,
        color: isSelected ? Colors.white : textColor,
        size: 20,
      ),
    );
  }
}

class _ReciterTrailing extends StatelessWidget {
  final Reciter reciter;
  final bool isSelected;

  const _ReciterTrailing({required this.reciter, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? primary.withOpacity(0.2)
                : textColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'ID: ${reciter.id}',
            style: GoogleFonts.poppins(
              color: isSelected ? primary : textColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (isSelected) ...[
          const SizedBox(width: 8),
          Icon(Icons.check_circle, color: primary),
        ],
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSelect;

  const _ActionButtons({required this.onCancel, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onCancel,
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
            onPressed: onSelect,
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
    );
  }
}
