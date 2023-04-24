import 'package:flutter/material.dart';
import 'package:my_app/models/client.dart';
import 'package:my_app/providers/trainings_provider.dart';
import 'package:my_app/providers/clients_provider.dart';
import 'package:provider/provider.dart';

class TrainingCreateScreen extends StatefulWidget {
  final DateTime? selectedDay;
  final String? clientId;

  TrainingCreateScreen({this.selectedDay, this.clientId});


  @override
  _TrainingCreateScreenState createState() => _TrainingCreateScreenState();
}

class _TrainingCreateScreenState extends State<TrainingCreateScreen> {
  final _titleController = TextEditingController();
  DateTime? _selectedDateTime;
  Client? _selectedClient;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDay != null) {
      _selectedDateTime = widget.selectedDay;
    }
    if (widget.clientId != null) {
      _selectedClient = Provider.of<ClientsProvider>(context, listen: false)
        .getClientById(widget.clientId!);
    }
  }
  

  void _submitForm(BuildContext context) {
    if (_titleController.text.isEmpty || _selectedDateTime == null || _selectedClient == null) {
      return;
    }

    final data = {
      'title': _titleController.text,
      'dateTime': _selectedDateTime!.toIso8601String(),
      'userId': _selectedClient!.id,
    };

    Provider.of<TrainingsProvider>(context, listen: false).addTraining(data);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final clientsData = Provider.of<ClientsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Training'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Training Title'),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Select Date & Time'),
              subtitle: Text(_selectedDateTime == null
                  ? 'No date selected'
                  : '${_selectedDateTime!.toIso8601String()}'),
              onTap: () async {
                if (_selectedDateTime == null) {
                  _selectedDateTime = DateTime.now();
                }

                // Если clientId равен null, выбираем только время.
                if (widget.clientId == null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        _selectedDateTime!.year,
                        _selectedDateTime!.month,
                        _selectedDateTime!.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                } else {
                  // Иначе, выбираем и дату, и время.
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateTime!,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                }
              },
            ),

            SizedBox(height: 16),
            // Отображаем выбор клиента только если widget.clientId равно null (создание тренировки из экрана календаря)
            if (widget.clientId == null)
              ListTile(
                title: Text('Select Client'),
                subtitle: Text(_selectedClient == null
                    ? 'No client selected'
                    : '${_selectedClient!.name}'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text('Select Client'),
                      children: clientsData.clients.map((client) {
                        return ListTile(
                          title: Text(client.name),
                          onTap: () {
                            setState(() {
                              _selectedClient = client;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _submitForm(context),
                child: Text('Create Training'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}