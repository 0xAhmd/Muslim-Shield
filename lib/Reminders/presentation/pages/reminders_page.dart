import 'package:azkar/Reminders/presentation/widgets/shimmers.dart';

import '../../data/models/reminder_card.dart';
import 'package:azkar/Reminders/data/repo/reminders_repo_impl.dart';
import 'package:azkar/Reminders/data/services/events_api_service.dart';
import 'package:azkar/Reminders/data/services/notification_service.dart';
import 'package:azkar/Reminders/presentation/bloc/reminders_bloc.dart';
import 'package:azkar/Reminders/presentation/bloc/reminders_event.dart';
import 'package:azkar/Reminders/presentation/bloc/reminders_state.dart';
import 'package:azkar/Reminders/presentation/widgets/calendar.dart';
import 'package:azkar/Reminders/presentation/widgets/event_list.dart';
import 'package:azkar/Reminders/presentation/widgets/reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/constants.dart';
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
    _tabController = TabController(length: 2, vsync: this);
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
          onPressed: () {
            Navigator.pop(context);
          },
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
          tabs: const [
            Tab(text: 'Calendar'),
            Tab(text: 'Today'),
          ],
        ),
      ),
      body: BlocBuilder<RemindersBloc, RemindersState>(
        builder: (context, state) {
          if (state is RemindersLoading) {
            return TabBarView(
              controller: _tabController,
              children: [buildCalendarShimmer(), buildTodayShimmer()],
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
              children: [_buildCalendarTab(state), _buildTodayTab(state)],
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

  Widget _buildTodayTab(RemindersLoaded state) {
    final todayReminders = state.reminders.where((reminder) {
      final today = DateTime.now();
      return reminder.createdAt.year == today.year &&
          reminder.createdAt.month == today.month &&
          reminder.createdAt.day == today.day;
    }).toList();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (todayReminders.isEmpty) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: textColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No reminders for today',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              ...todayReminders.map(
                (reminder) => ReminderCardWidget(
                  reminder: reminder,
                  onTap: () => _handleReminderTap(context, reminder),
                  onMarkAsRead: () => context.read<RemindersBloc>().add(
                    MarkReminderAsRead(reminder.id),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _handleReminderTap(BuildContext context, reminder) {
    switch (reminder.type) {
      case ReminderType.fridaySurah:
        _showSnackBar(context, 'Opening Surah Al-Kahf...');
        break;
      case ReminderType.prayerUpcoming:
        _showSnackBar(context, 'Opening Prayer Times...');
        break;
      case ReminderType.eidGreeting:
        _showEidGreetingDialog(context, reminder);
        break;
      default:
        _showSnackBar(context, 'Reminder opened');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: primary));
  }

  void _showEidGreetingDialog(BuildContext context, reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '🌙 ${reminder.title}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Eid Mubarak! May this blessed day bring joy, peace, and prosperity to you and your family.',
          style: GoogleFonts.poppins(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Ameen',
              style: GoogleFonts.poppins(
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
