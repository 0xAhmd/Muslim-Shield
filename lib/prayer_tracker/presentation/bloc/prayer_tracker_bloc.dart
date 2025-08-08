import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'prayer_tracker_event.dart';
part 'prayer_tracker_state.dart';

class PrayerTrackerBloc extends Bloc<PrayerTrackerEvent, PrayerTrackerState> {
  PrayerTrackerBloc() : super(PrayerTrackerInitial()) {
    on<PrayerTrackerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
