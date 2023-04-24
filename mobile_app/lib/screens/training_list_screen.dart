import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/training.dart';
import '../providers/trainings_provider.dart';
import '../screens/training_edit_screen.dart';
import 'package:my_app/models/client.dart';
import 'package:my_app/providers/clients_provider.dart';

import 'training_create_screen.dart';

class TrainingListScreen extends StatefulWidget {
  @override
  _TrainingListScreenState createState() => _TrainingListScreenState();
}

class _TrainingListScreenState extends State<TrainingListScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Training> _selectedDayTrainings = [];

  Map<DateTime, List<Training>> _groupTrainingsByDate(
      List<Training> trainings) {
    LinkedHashMap<DateTime, List<Training>> trainingsByDate =
        LinkedHashMap<DateTime, List<Training>>(
      equals: isSameDay,
      hashCode: (dateTime) =>
          dateTime.day * 1000000 + dateTime.month * 1000 + dateTime.year,
    );
    for (Training training in trainings) {
      DateTime date = DateTime(
        training.dateTime.year,
        training.dateTime.month,
        training.dateTime.day,
      );
      if (trainingsByDate.containsKey(date)) {
        trainingsByDate[date]!.add(training);
      } else {
        trainingsByDate[date] = [training];
      }
    }
    return trainingsByDate;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TrainingsProvider>(context, listen: false).fetchTrainings();
  }

  @override
  Widget build(BuildContext context) {
    final trainingsData = Provider.of<TrainingsProvider>(context);
    final clientsData = Provider.of<ClientsProvider>(context);

    Map<DateTime, List<Training>> _trainingsByDate =
        _groupTrainingsByDate(trainingsData.trainings);

    // print("============");
    // print(_trainingsByDate);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar<Training>(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            eventLoader: (day) => _trainingsByDate[day] ?? [],
            calendarBuilders: CalendarBuilders<Training>(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedDayTrainings = _trainingsByDate[selectedDay] ?? [];
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Column(
            children: _selectedDay == null ||
                    !_trainingsByDate.containsKey(_selectedDay)
                ? []
                : _trainingsByDate[_selectedDay]!
                    .map(
                      (training) => ListTile(
                        title: Text(
                            '${clientsData.getClientName(training.clientId)} | ${training.title}'),
                        subtitle: Text(training.dateTime.toString()),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrainingEditScreen(
                                // trainingId: training.id,
                                // clientId: training.clientId,
                                training: training,
                              ),
                            ),
                          ).then((isUpdated) {
                            if (isUpdated != null && isUpdated) {
                              Provider.of<TrainingsProvider>(context, listen: false).fetchTrainings();
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TrainingCreateScreen(selectedDay: _selectedDay),
                ),
              );
            },
            child: Text('Add New Training'),
          ),
        ],
      ),
    );
  }
}
