import 'package:flutter/material.dart';
import 'package:my_app/models/training.dart';
import 'package:provider/provider.dart';
import '../providers/trainings_provider.dart';
import 'package:flutter/widgets.dart';

class TrainingEditScreen extends StatefulWidget {
  // final String? trainingId;
  // final String? clientId;

  final Training training;

  // const TrainingEditScreen({Key? key, this.trainingId, this.clientId})
  const TrainingEditScreen({Key? key, required this.training})
      : super(key: key);

  @override
  State<TrainingEditScreen> createState() => _TrainingEditScreenState();
}

class _TrainingEditScreenState extends State<TrainingEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    final trainingId = widget.training.id;
    print(widget.training.id);
    if (widget.training.id != null) {
    final training = Provider.of<TrainingsProvider>(context, listen: false)
        .getById(trainingId!);
       _title = widget.training.title;
       _dateTime = widget.training.dateTime;
      print("  if (widget.trainingId != null) { $training ");
    } else {
      print(" } else {");
      _title = ''; // Инициализируем _title пустой строкой для новой тренировки
      _dateTime = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = DateTime(picked.year, picked.month, picked.day,
            _dateTime?.hour ?? 0, _dateTime?.minute ?? 0);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime ?? DateTime.now()),
    );
    if (picked != null &&
        picked != TimeOfDay.fromDateTime(_dateTime ?? DateTime.now())) {
      setState(() {
        _dateTime = DateTime(_dateTime?.year ?? 0, _dateTime?.month ?? 0,
            _dateTime?.day ?? 0, picked.hour, picked.minute);
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print("widget ${widget.training.id}");

      final data = {
        'title': _title ?? '',
        'dateTime':
            _dateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'userId': widget.training.clientId,
      };

      // Уберите условие, так как экран предназначен только для редактирования существующих тренировок
      Provider.of<TrainingsProvider>(context, listen: false)
          .updateTraining(widget.training.id!, data);

      Navigator.pop(context, true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.training.id == null ? 'Add Training' : 'Edit Training'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                  TextButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Select Time'),
                  ),
                ],
              ),
              Text('Date and Time: $_dateTime'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
