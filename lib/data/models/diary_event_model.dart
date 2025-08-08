class DiaryEvent {
  final int? id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;

  DiaryEvent({
    this.id,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  factory DiaryEvent.fromMap(Map<String, dynamic> map) {
    return DiaryEvent(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
    );
  }
}
