class Event {
  final String eventID;
  final String eventName; // New property
  final String eventType;
  final int eventRequirement;
  final int eventBudget;
  final double? eventMinimumHeight;
  final int? eventMinimumRating;
  final int? eventMinimumAge;
  final String eventDate;
  final String eventTime;
  final bool foodProvided;
  final String? eventLanguage;
  final String eventLocation;
  final String ownerID;

  Event({
    required this.eventID,
    required this.eventName, // New property
    required this.eventType,
    required this.eventRequirement,
    required this.eventBudget,
    this.eventMinimumHeight,
    this.eventMinimumRating,
    this.eventMinimumAge,
    required this.eventDate,
    required this.eventTime,
    required this.foodProvided,
    this.eventLanguage,
    required this.eventLocation,
    required this.ownerID,
  });

  // Factory constructor to create an Event from a JSON object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventID: json['event_id'],
      eventName: json['event_name'], // New property
      eventType: json['type'],
      eventRequirement: json['requirement'],
      eventBudget: json['budget'],
      eventMinimumHeight: json['minimum_height'] * 1.0,
      eventMinimumRating: json['minimum_rating'],
      eventMinimumAge: json['minimum_age'],
      eventDate: json['date'],
      eventTime: json['time'],
      foodProvided:
          json['food_provided'] == 1, // Assuming 1 means true and 0 means false
      eventLanguage: json['language'],
      eventLocation: json['location'],
      ownerID: json['owner_id'],
    );
  }
}
