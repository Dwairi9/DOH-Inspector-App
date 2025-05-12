import 'dart:convert';

class DepartmentUser {
  final String username;
  final String fullName;
  final String cashierId;
  final String employeeId;
  final String department;
  final String firstName;
  final String firstNameDisp;
  final String middleName;
  final String middleNameDisp;
  final String lastName;
  final String lastNameDisp;
  final bool isInspector;
  final String title;
  final String titleDisp;
  final String email;
  DepartmentUser({
    required this.username,
    required this.fullName,
    required this.cashierId,
    required this.employeeId,
    required this.department,
    required this.firstName,
    required this.firstNameDisp,
    required this.middleName,
    required this.middleNameDisp,
    required this.lastName,
    required this.lastNameDisp,
    required this.isInspector,
    required this.title,
    required this.titleDisp,
    required this.email,
  });

  DepartmentUser copyWith({
    String? username,
    String? fullName,
    String? cashierId,
    String? employeeId,
    String? department,
    String? firstName,
    String? firstNameDisp,
    String? middleName,
    String? middleNameDisp,
    String? lastName,
    String? lastNameDisp,
    bool? isInspector,
    String? title,
    String? titleDisp,
    String? email,
  }) {
    return DepartmentUser(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      cashierId: cashierId ?? this.cashierId,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      firstName: firstName ?? this.firstName,
      firstNameDisp: firstNameDisp ?? this.firstNameDisp,
      middleName: middleName ?? this.middleName,
      middleNameDisp: middleNameDisp ?? this.middleNameDisp,
      lastName: lastName ?? this.lastName,
      lastNameDisp: lastNameDisp ?? this.lastNameDisp,
      isInspector: isInspector ?? this.isInspector,
      title: title ?? this.title,
      titleDisp: titleDisp ?? this.titleDisp,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'fullName': fullName,
      'cashierId': cashierId,
      'employeeId': employeeId,
      'department': department,
      'firstName': firstName,
      'firstNameDisp': firstNameDisp,
      'middleName': middleName,
      'middleNameDisp': middleNameDisp,
      'lastName': lastName,
      'lastNameDisp': lastNameDisp,
      'isInspector': isInspector,
      'title': title,
      'titleDisp': titleDisp,
      'email': email,
    };
  }

  factory DepartmentUser.fromMap(Map<String, dynamic> map) {
    return DepartmentUser(
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      cashierId: map['cashierId'] ?? '',
      employeeId: map['employeeId'] ?? '',
      department: map['department'] ?? '',
      firstName: map['firstName'] ?? '',
      firstNameDisp: map['firstNameDisp'] ?? '',
      middleName: map['middleName'] ?? '',
      middleNameDisp: map['middleNameDisp'] ?? '',
      lastName: map['lastName'] ?? '',
      lastNameDisp: map['lastNameDisp'] ?? '',
      isInspector: map['isInspector'] ?? false,
      title: map['title'] ?? '',
      titleDisp: map['titleDisp'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DepartmentUser.fromJson(String source) => DepartmentUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DepartmentUser(username: $username, fullName: $fullName, cashierId: $cashierId, employeeId: $employeeId, department: $department, firstName: $firstName, firstNameDisp: $firstNameDisp, middleName: $middleName, middleNameDisp: $middleNameDisp, lastName: $lastName, lastNameDisp: $lastNameDisp, isInspector: $isInspector, title: $title, titleDisp: $titleDisp, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DepartmentUser &&
        other.username == username &&
        other.fullName == fullName &&
        other.cashierId == cashierId &&
        other.employeeId == employeeId &&
        other.department == department &&
        other.firstName == firstName &&
        other.firstNameDisp == firstNameDisp &&
        other.middleName == middleName &&
        other.middleNameDisp == middleNameDisp &&
        other.lastName == lastName &&
        other.lastNameDisp == lastNameDisp &&
        other.isInspector == isInspector &&
        other.title == title &&
        other.titleDisp == titleDisp &&
        other.email == email;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        fullName.hashCode ^
        cashierId.hashCode ^
        employeeId.hashCode ^
        department.hashCode ^
        firstName.hashCode ^
        firstNameDisp.hashCode ^
        middleName.hashCode ^
        middleNameDisp.hashCode ^
        lastName.hashCode ^
        lastNameDisp.hashCode ^
        isInspector.hashCode ^
        title.hashCode ^
        titleDisp.hashCode ^
        email.hashCode;
  }
}
