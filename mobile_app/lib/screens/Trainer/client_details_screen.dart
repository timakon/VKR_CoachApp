import 'package:flutter/material.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/screens/Trainer/training_create_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/clients_provider.dart';
import '../../models/client.dart';
import '../../providers/trainings_provider.dart';
import './training_edit_screen.dart';




class ClientDetailsScreen extends StatefulWidget {
  final String clientId;

  ClientDetailsScreen({required this.clientId});

  @override
  _ClientDetailsScreenState createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {

@override
void initState() {
  super.initState();
  final trainerId = Provider.of<AuthProvider>(context, listen: false).userId;
    if (trainerId != null) {
    Provider.of<TrainingsProvider>(context, listen: false).fetchTrainings(trainerId);
  }
}

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<ClientsProvider>(context).getClientById(widget.clientId);
    final trainings = Provider.of<TrainingsProvider>(context).trainings.where((training) => training.clientId == widget.clientId).toList();

    // Сортируем тренировки по времени
    trainings.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client Name: ${client.name}'),
            Text('Client Email: ${client.email}'),
            const SizedBox(height: 20),
            const Text('Trainings:'),
            Expanded(
              child: ListView.builder(
                itemCount: trainings.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(trainings[i].title),
                  subtitle: Text(trainings[i].dateTime.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingEditScreen(training: trainings[i]),
                      ),
                    ).then((isUpdated) {
                            if (isUpdated != null && isUpdated) {
                              final trainerId = Provider.of<AuthProvider>(context, listen: false).userId;
                              Provider.of<TrainingsProvider>(context, listen: false).fetchTrainings(trainerId!);
                            }
                          });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrainingCreateScreen(clientId: client.id),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}