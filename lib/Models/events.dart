class Event {
  final String eventID;
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
      eventID: json['EventID'],
      eventType: json['Type'],
      eventRequirement: json['Requirement'],
      eventBudget: json['Budget'],
      eventMinimumHeight: json['MinimumHeight'] * 1.0,
      eventMinimumRating: json['MinimumRating'],
      eventMinimumAge: json['MinimumAge'],
      eventDate: json['Date'],
      eventTime: json['Time'],
      foodProvided:
          json['FoodProvided'] == 1, // Assuming 1 means true and 0 means false
      eventLanguage: json['Language'],
      eventLocation: json['Location'],
      ownerID: json['OwnerID'],
    );
  }
}
