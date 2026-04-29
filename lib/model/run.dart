class Run {
  final String id;
  final String location;
  final double distance;
  final int participants;
  final String userId;

  Run({
    required this.id,
    required this.location,
    required this.distance,
    required this.participants,
    required this.userId,
  });

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      id: json['id'].toString(),
      location: json['location'] ?? '',
      distance: (json['distance'] as num).toDouble(),
      participants: json['participants'] as int,
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'distance': distance,
      'participants': participants,
      'user_id': userId,
    };
  }
}