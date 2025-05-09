class LocalUser {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String language;
  final String country;
  final bool receiveEmails;

  LocalUser({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.language,
    required this.country,
    required this.receiveEmails,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'password': password,
    'language': language,
    'country': country,
    'receiveEmails': receiveEmails,
  };

  factory LocalUser.fromJson(Map<String, dynamic> json) => LocalUser(
    email: json['email'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    password: json['password'],
    language: json['language'],
    country: json['country'],
    receiveEmails: json['receiveEmails'],
  );
}
