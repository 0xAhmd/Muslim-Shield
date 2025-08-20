import '../../../constants.dart';
import '../../../surah/data/repo/surah_repo.dart';
import '../cubit/juzz_cubit.dart';
import '../cubit/juzz_state.dart';
import '../widgets/juzz_content_view.dart';
import '../widgets/juzz_detail_appbar.dart';
import '../widgets/juzz_error_view.dart';
import '../widgets/juzz_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzDetailScreen extends StatefulWidget {
  final int juzzNumber;

  const JuzzDetailScreen({super.key, required this.juzzNumber});

  @override
  State<JuzzDetailScreen> createState() => _JuzzDetailScreenState();
}

class _JuzzDetailScreenState extends State<JuzzDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _lastReadAyahIndex;
  late JuzzCubit _detailCubit;

  @override
  void initState() {
    super.initState();
    // Create a separate cubit instance for this detail screen
    _detailCubit = JuzzCubit(repository: SurahRepository());
    _detailCubit.loadJuzzDetails(widget.juzzNumber);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _detailCubit.close();
    super.dispose();
  }

  void _onLastReadChanged(int ayahIndex) {
    setState(() {
      _lastReadAyahIndex = ayahIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JuzzDetailAppBar(
        juzzNumber: widget.juzzNumber,
        onRefresh: () => _detailCubit.loadJuzzDetails(widget.juzzNumber),
      ),
      body: BlocProvider.value(
        value: _detailCubit,
        child: BlocBuilder<JuzzCubit, JuzzState>(
          builder: (context, state) {
            if (state is JuzzDetailLoading) {
              return JuzzLoadingView(juzzNumber: widget.juzzNumber);
            }

            if (state is JuzzDetailError) {
              return JuzzErrorView(
                state: state,
                onRetry: () => _detailCubit.retry(),
                onBack: () => Navigator.pop(context),
              );
            }

            if (state is JuzzDetailLoaded) {
              return JuzzContentView(
                juzz: state.juzz,
                juzzNumber: widget.juzzNumber,
                scrollController: _scrollController,
                lastReadAyahIndex: _lastReadAyahIndex,
                onLastReadChanged: _onLastReadChanged,
              );
            }

            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Text(
        'Initializing...',
        style: GoogleFonts.poppins(color: textColor),
      ),
    );
  }
}
