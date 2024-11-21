class Employee {
  final String id; // Alterado de int para String
  final String name;
  final String role;
  final String image;
  final String phone;
  final String admissionDate;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.image,
    required this.phone,
    required this.admissionDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'].toString(),
      name: json['name'],
      role: json['role'],
      image: json['image'],
      phone: json['phone'],
      admissionDate: json['admission_date'],
    );
  }
}
