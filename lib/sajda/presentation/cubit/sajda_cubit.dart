import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sajda_state.dart';

class SajdaCubit extends Cubit<SajdaState> {
  SajdaCubit() : super(SajdaInitial());
}
