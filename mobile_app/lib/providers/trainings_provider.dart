import 'package:flutter/material.dart';
import '../models/training.dart';
import '../api.dart';

class TrainingsProvider with ChangeNotifier {
  List<Training> _trainings = [];

  List<Training> get trainings => _trainings;

  final ApiService _apiService = ApiService();

  Future<void> fetchTrainings(String trainerId) async {
    final trainingsJson = await _apiService.getAll("trainings", trainerId: trainerId);
    _trainings = trainingsJson.map((json) => Training.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> getAllTrainings() async {
    try {
      final response = await _apiService.getTrainings();
      final List<Training> loadedTrainings = [];
      response.forEach((trainingData) {
        loadedTrainings.add(Training.fromJson(trainingData));
      });
      _trainings = loadedTrainings;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addTraining(Map<String, String?> data) async {
    final newTrainingJson = await _apiService.add("trainings", data);
    final newTraining = Training.fromJson(newTrainingJson);
    _trainings.add(newTraining);
    notifyListeners();
  }


  Future<void> saveTraining(Training training, {String? trainingId}) async {
    final trainingData = training.toJson();
    if (trainingId != null) {
      await _apiService.update("trainings", trainingId, trainingData);
      final updatedTraining = Training.fromJson(trainingData);
      final index = _trainings.indexWhere((existingTraining) => existingTraining.id == trainingId);
      _trainings[index] = updatedTraining;
    } else {
      final newTrainingJson = await _apiService.add("trainings", trainingData);
      final newTraining = Training.fromJson(newTrainingJson);
      _trainings.add(newTraining);
    }
    notifyListeners();
  }

  Future<void> updateTraining(String id, Map<String, dynamic> data) async {
    await _apiService.update("trainings", id, data);
    final updatedTraining = Training.fromJson(data);
    final index = _trainings.indexWhere((training) => training.id == id);
    _trainings[index] = updatedTraining;
    notifyListeners();
  }

  Future<void> deleteTraining(String id) async {
    await _apiService.delete("trainings", id);
    _trainings.removeWhere((training) => training.id == id);
    notifyListeners();
  }

  Future<void> getById(String trainingId) async {
    final response = await _apiService.getById("trainings", trainingId);
  }
}
