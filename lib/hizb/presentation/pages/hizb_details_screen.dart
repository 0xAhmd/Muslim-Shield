import '../../../constants.dart';
import '../cubit/hizb_cubit.dart';
import '../cubit/hizb_state.dart';
import '../widgets/hizb_content_view.dart';
import '../widgets/hizb_err_view.dart';
import '../widgets/hizb_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HizbDetailScreen extends StatefulWidget {
  final int hizbNumber;
  final HizbCubit hizbCubit;

  const HizbDetailScreen({
    super.key,
    required this.hizbNumber,
    required this.hizbCubit,
  });

  @override
  State<HizbDetailScreen> createState() => _HizbDetailScreenState();
}

class _HizbDetailScreenState extends State<HizbDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _lastReadAyahIndex;

  @override
  void initState() {
    super.initState();
    widget.hizbCubit.loadHizbDetails(widget.hizbNumber);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      body: BlocProvider.value(
        value: widget.hizbCubit,
        child: BlocBuilder<HizbCubit, HizbState>(
          builder: (context, state) {
            if (state is HizbDetailLoading) {
              return HizbLoadingView(hizbNumber: widget.hizbNumber);
            }

            if (state is HizbDetailError) {
              return HizbErrorView(
                message: state.message,
                state: state,
                onRetry: () => widget.hizbCubit.retry(),
                onBack: () => Navigator.pop(context),
              );
            }

            if (state is HizbDetailLoaded) {
              return HizbContentView(
                hizb: state.hizb,
                hizbNumber: widget.hizbNumber,
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

class HizbDetailAppBar {}
