class Student {
  int? id;
  String name;
  String rollNo;
  String course;
  String email;
  String phone;

  Student({
    this.id,
    required this.name,
    required this.rollNo,
    required this.course,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rollNo': rollNo,
      'course': course,
      'email': email,
      'phone': phone,
    };
  }
}
