import 'package:azkar/tasbih/data/data_source/tasbih_data_source.dart';
import 'package:azkar/tasbih/data/repo/tasbih_repo.dart';
import 'package:azkar/tasbih/presentation/widgets/counter_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../cubit/tasbih_cubit.dart';
import '../cubit/tasbih_state.dart';
import '../widgets/tasbih_selector.dart';

class TasbihPage extends StatelessWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TasbihCubit(TasbihRepository(TasbihLocalDatasource()))
            ..initializeTasbih(),
      child: const TasbihView(),
    );
  }
}

class TasbihView extends StatelessWidget {
  const TasbihView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TasbihCubit, TasbihState>(
        builder: (context, state) {
          if (state is TasbihLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasbihError) {
            return Center(
              child: Text(
                state.message,
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            );
          }

          if (state is TasbihLoaded) {
            return Column(
              children: [
                SizedBox(height: 40.h),
                _buildHeader(context, state),
                SizedBox(height: 30.h),
                TasbihSelector(
                  tasbihList: state.tasbihList,
                  selectedTasbih: state.selectedTasbih,
                  onTasbihSelected: (id) {
                    context.read<TasbihCubit>().selectTasbih(id);
                  },
                ),
                const Spacer(),
                if (state.selectedTasbih != null) ...[
                  _buildCurrentTasbihInfo(state.selectedTasbih!),
                  SizedBox(height: 40.h),
                  CounterButton(
                    onTap: () {
                      context.read<TasbihCubit>().incrementCount();
                    },
                    isCompleted: state.isCompleted,
                  ),
                  SizedBox(height: 30.h),
                  _buildActionButtons(context),
                ],
                const Spacer(),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TasbihLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Text(
            'Digital Tasbih',
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.read<TasbihCubit>().resetAllCounts();
            },
            icon: const Icon(Icons.refresh, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTasbihInfo(tasbih) {
    return Column(
      children: [
        Text(
          tasbih.arabicText,
          style: GoogleFonts.amiri(
            fontSize: 32.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          tasbih.translation,
          style: GoogleFonts.poppins(fontSize: 14.sp, color: textColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          '${tasbih.currentCount}',
          style: GoogleFonts.poppins(
            fontSize: 48.sp,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        Text(
          'of ${tasbih.targetCount}',
          style: GoogleFonts.poppins(fontSize: 16.sp, color: textColor),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.refresh,
          label: 'Reset',
          onPressed: () {
            context.read<TasbihCubit>().resetCount();
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: grey,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 14.sp, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
