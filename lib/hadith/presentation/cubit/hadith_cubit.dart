import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  HadithCubit() : super(HadithInitial());
}
