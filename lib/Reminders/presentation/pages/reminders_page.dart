import '../widgets/shimmers.dart';
import '../../data/repo/reminders_repo_impl.dart';
import '../../data/services/events_api_service.dart';
import '../../data/services/notification_service.dart';
import '../bloc/reminders_bloc.dart';
import '../bloc/reminders_event.dart';
import '../bloc/reminders_state.dart';
import '../widgets/calendar.dart';
import '../widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants.dart';
import 'package:google_fonts/google_fonts.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemindersBloc(
        RemindersRepositoryImpl(
          EventsApiServiceFactory.create(),
          NotificationService(),
        ),
      )..add(LoadReminders()),
      child: const _RemindersPageView(),
    );
  }
}

class _RemindersPageView extends StatefulWidget {
  const _RemindersPageView();

  @override
  State<_RemindersPageView> createState() => _RemindersPageViewState();
}

class _RemindersPageViewState extends State<_RemindersPageView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    context.read<RemindersBloc>().add(ScheduleNotifications());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Islamic Reminders',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<RemindersBloc>().add(RefreshReminders());
            },
            icon: const Icon(Icons.refresh, color: textColor),
          ),
        ],
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          labelColor: primary,
          unselectedLabelColor: textColor,
          indicatorColor: primary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Calendar')],
        ),
      ),
      body: BlocBuilder<RemindersBloc, RemindersState>(
        builder: (context, state) {
          if (state is RemindersLoading) {
            return TabBarView(
              controller: _tabController,
              children: [buildCalendarShimmer()],
            );
          }

          if (state is RemindersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: textColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: GoogleFonts.poppins(color: textColor, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RemindersBloc>().add(RefreshReminders());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is RemindersLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [_buildCalendarTab(state)],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCalendarTab(RemindersLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          IslamicCalendarWidget(
            events: state.events,
            onDaySelected: (selectedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                EventsListWidget(
                  events: state.events.where((event) {
                    return event.date.year == _selectedDay.year &&
                        event.date.month == _selectedDay.month &&
                        event.date.day == _selectedDay.day;
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
