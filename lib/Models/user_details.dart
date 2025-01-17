class UserDetails {
  String userId;
  String fullName;
  String phoneNumber;
  String photoUrl;
  int rating;
  int experienceYear;
  int workDone;
  String dateOfBirth;
  String height;
  int age;
  String gender;

  UserDetails({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.photoUrl,
    required this.rating,
    required this.experienceYear,
    required this.workDone,
    required this.dateOfBirth,
    required this.height,
    required this.age,
    required this.gender,
  });

  Future<void> fromJson(Map<String, dynamic> json) async {
    userId = json['UserId'];
    fullName = json['FullName'];
    phoneNumber = json['PhoneNumber'];
    photoUrl = json['PhotoURL'];
    rating = json['Rating'];
    experienceYear = json['ExperienceYear'];
    workDone = json['WorkDone'];
    dateOfBirth = json['DateOfBirth'];
    height = json['Height'];
    age = json['Age'];
    gender = json['Gender'];
  }
}
