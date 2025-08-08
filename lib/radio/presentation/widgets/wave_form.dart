import '../cubit/radio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/radio_cubit.dart';
import '../../../constants.dart';

class WaveformAnimation extends StatefulWidget {
  const WaveformAnimation({super.key});

  @override
  State<WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<WaveformAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _barControllers;
  final int _barCount = 5;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _barControllers = List.generate(
      _barCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 200)),
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _barControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RadioCubit, RadioState>(
      listener: (context, state) {
        if (state is RadioPlaying) {
          _startAnimation();
        } else {
          _stopAnimation();
        }
      },
      child: Container(
        height: 94.h,
        width: 336.w,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.2), width: 1),
        ),
        child: BlocBuilder<RadioCubit, RadioState>(
          builder: (context, state) {
            if (state is RadioPlaying) {
              return _buildWaveform();
            } else {
              return _buildIslamicPattern();
            }
          },
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_barCount, (index) {
          return AnimatedBuilder(
            animation: _barControllers[index],
            builder: (context, child) {
              return Container(
                width: 4,
                height: 20 + (_barControllers[index].value * 40),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildIslamicPattern() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.radio, size: 48, color: primary.withOpacity(0.6)),
          const SizedBox(height: 12),
          Text(
            'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
            style: TextStyle(
              color: primary.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  void _startAnimation() {
    _animationController.repeat();
    for (int i = 0; i < _barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _barControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _stopAnimation() {
    _animationController.stop();
    for (var controller in _barControllers) {
      controller.stop();
      controller.reset();
    }
  }
}
