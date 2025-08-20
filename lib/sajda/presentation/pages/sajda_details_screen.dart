import '../../data/repo/sajda_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../cubit/sajda_cubit.dart';
import '../cubit/sajda_state.dart';
import '../widget/sajda_loading.dart';
import '../widget/sajda_err_view.dart';

class SajdaDetailScreen extends StatefulWidget {
  final int sajdaId;
  final SajdaCubit sajdaCubit;

  const SajdaDetailScreen({
    super.key,
    required this.sajdaId,
    required this.sajdaCubit,
  });

  @override
  State<SajdaDetailScreen> createState() => _SajdaDetailScreenState();
}

class _SajdaDetailScreenState extends State<SajdaDetailScreen> {
  late SajdaCubit _detailCubit;

  @override
  void initState() {
    super.initState();
    // Create a separate cubit instance for the detail screen
    _detailCubit = SajdaCubit(repository: SajdaRepository());
    _detailCubit.loadSajdaDetails(widget.sajdaId);
  }

  @override
  void dispose() {
    _detailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _detailCubit,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: BlocBuilder<SajdaCubit, SajdaState>(
          builder: (context, state) {
            return _buildBody(state);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: scaffoldBackgroundColor,
      leading: IconButton(
        onPressed: () {
          // Simply pop without affecting the main cubit
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back, color: textColor),
      ),
      title: Text(
        'Sajda ${widget.sajdaId}',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildBody(SajdaState state) {
    if (state is SajdaDetailLoading) {
      return SajdaLoadingView(sajdaId: widget.sajdaId);
    }

    if (state is SajdaDetailError) {
      return SajdaErrorView(
        message: state.message,
        state: state,
        onRetry: () => _detailCubit.retry(),
        onBack: () => Navigator.of(context).pop(),
      );
    }

    if (state is SajdaDetailLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSajdaHeader(state),
            const SizedBox(height: 24),
            _buildSurahInfo(state),
            const SizedBox(height: 24),
            _buildAyahCard(state),
            const SizedBox(height: 24),
            _buildAdditionalInfo(state),
            const SizedBox(height: 100),
          ],
        ),
      );
    }

    return SajdaLoadingView(sajdaId: widget.sajdaId);
  }

  Widget _buildSajdaHeader(SajdaDetailLoaded state) {
    final sajda = state.sajdaAyah;
    final isObligatory = sajda.isObligatory;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isObligatory
                ? Colors.red.withOpacity(0.1)
                : primary.withOpacity(0.1),
            isObligatory
                ? Colors.red.withOpacity(0.05)
                : primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isObligatory
              ? Colors.red.withOpacity(0.3)
              : primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isObligatory
                  ? Colors.red.withOpacity(0.2)
                  : primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isObligatory ? Colors.red : primary,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${sajda.sajda.id}',
                style: GoogleFonts.poppins(
                  color: isObligatory ? Colors.red : primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isObligatory
                  ? Colors.red.withOpacity(0.2)
                  : orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isObligatory ? Colors.red : orange,
                width: 1,
              ),
            ),
            child: Text(
              isObligatory ? 'Obligatory' : 'Recommended',
              style: GoogleFonts.poppins(
                color: isObligatory ? Colors.red : orange,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahInfo(SajdaDetailLoaded state) {
    final sajda = state.sajdaAyah;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Surah Information',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sajda.surah.englishName,
                      style: GoogleFonts.poppins(
                        color: primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sajda.surah.name,
                      style: GoogleFonts.amiri(
                        color: textColor.withOpacity(0.8),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${sajda.surah.number}',
                  style: GoogleFonts.poppins(
                    color: primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAyahCard(SajdaDetailLoaded state) {
    final sajda = state.sajdaAyah;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: background.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Ayah ${sajda.numberInSurah}',
                style: GoogleFonts.poppins(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              sajda.text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(SajdaDetailLoaded state) {
    final sajda = state.sajdaAyah;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoGrid([
          _InfoItem(
            icon: Icons.bookmark_outline,
            label: 'Juz',
            value: '${sajda.juz}',
            color: primary,
          ),
          _InfoItem(
            icon: Icons.article_outlined,
            label: 'Page',
            value: '${sajda.page}',
            color: orange,
          ),
          _InfoItem(
            icon: Icons.location_on_outlined,
            label: 'Manzil',
            value: '${sajda.manzil}',
            color: Colors.blue,
          ),
          _InfoItem(
            icon: Icons.auto_stories_outlined,
            label: 'Ruku',
            value: '${sajda.ruku}',
            color: Colors.green,
          ),
          _InfoItem(
            icon: Icons.fiber_manual_record_outlined,
            label: 'Hizb Quarter',
            value: '${sajda.hizbQuarter}',
            color: Colors.purple,
          ),
          _InfoItem(
            icon: Icons.format_list_numbered,
            label: 'Ayah Number',
            value: '${sajda.number}',
            color: Colors.cyan,
          ),
        ]),
      ],
    );
  }

  Widget _buildInfoGrid(List<_InfoItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio:
            2.5, // Increased a bit to reduce height & avoid overflow
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: item.color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: item.color, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: GoogleFonts.poppins(
                        color: textColor.withOpacity(0.7),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.value,
                      style: GoogleFonts.poppins(
                        color: item.color,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
