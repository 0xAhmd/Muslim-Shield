import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'masjid_state.dart';

class MasjidCubit extends Cubit<MasjidState> {
  MasjidCubit() : super(MasjidInitial());
}
