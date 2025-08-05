// lib/juzz/presentation/widgets/juzz_list_view.dart
import 'package:azkar/juzz/presentation/cubit/juzz_cubit.dart';
import 'package:azkar/juzz/presentation/cubit/juzz_state.dart';
import 'package:azkar/juzz/presentation/pages/juzz_details_screen.dart';
import 'package:azkar/juzz/presentation/widgets/juzz_tile.dart';
import 'package:azkar/juzz/presentation/widgets/search_indicator.dart';
import 'package:flutter/material.dart';

class JuzzListView extends StatelessWidget {
  final JuzzLoaded state;
  final JuzzCubit juzzCubit;

  const JuzzListView({super.key, required this.state, required this.juzzCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.searchQuery.isNotEmpty) JuzzSearchIndicator(state: state),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: state.filteredJuzz.length,
            separatorBuilder: (context, index) => Divider(
              color: const Color(0xFFAAAAAA).withOpacity(.35),
              thickness: 1,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final juzz = state.filteredJuzz[index];
              return JuzzTile(
                juzzSummary: juzz,
                searchQuery: state.searchQuery,
                onTap: () => _navigateToDetails(context, juzz.number),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToDetails(BuildContext context, int juzzNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            JuzzDetailScreen(juzzNumber: juzzNumber, juzzCubit: juzzCubit),
      ),
    );
  }
}
