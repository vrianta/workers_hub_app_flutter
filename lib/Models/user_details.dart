class UserDetails {
  String userId;
  String fullName;
  String email;
  String phoneNumber;
  String photoUrl;
  int rating;
  int experienceYear;
  int workDone;
  String dateOfBirth;
  String height;
  int age;
  String gender;

  bool isEmpty;

  UserDetails({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.rating,
    required this.experienceYear,
    required this.workDone,
    required this.dateOfBirth,
    required this.height,
    required this.age,
    required this.gender,
    this.isEmpty = false,
  });

  factory UserDetails.emptyObject() {
    return UserDetails(
        userId: "",
        fullName: "",
        email: "email",
        phoneNumber: "",
        photoUrl: "",
        rating: 0,
        experienceYear: 0,
        workDone: 0,
        dateOfBirth: "",
        height: "",
        age: 0,
        gender: "",
        isEmpty: true);
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return UserDetails.emptyObject();
    }
    return UserDetails(
        userId: json['UserId'],
        fullName: json['FullName'],
        email: json['Email'],
        phoneNumber: json['PhoneNumber'],
        photoUrl: json['PhotoURL'],
        rating: json['Rating'],
        experienceYear: json['ExperienceYear'],
        workDone: json['WorkDone'],
        dateOfBirth: json['DateOfBirth'],
        height: json['Height'],
        age: json['Age'],
        gender: json['Gender'],
        isEmpty: false);
  }

  void set(Map<String, dynamic> json) {
    userId = json['UserId'];
    fullName = json['FullName'];
    email = json['Email'];
    phoneNumber = json['PhoneNumber'];
    photoUrl = json['PhotoURL'];
    rating = json['Rating'];
    experienceYear = json['ExperienceYear'];
    workDone = json['WorkDone'];
    dateOfBirth = json['DateOfBirth'];
    height = json['Height'];
    age = json['Age'];
    gender = json['Gender'];
    isEmpty = false;
  }
}
