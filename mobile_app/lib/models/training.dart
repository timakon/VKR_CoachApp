class Training {
  final String? id;
  final String title;
  final DateTime dateTime;
  final String clientId;
  final String trainerId;

  Training({
    this.id,
    required this.title,
    required this.dateTime,
    required this.clientId,
     required this.trainerId,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['_id'],
      title: json['title'],
      dateTime: DateTime.parse(json['dateTime']),
      clientId: json['userId'],
      trainerId:  json['trainerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'clientId': clientId,
      'trainerId':trainerId,
    };
  }
}