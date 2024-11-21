import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/employee.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late Future<List<Employee>> _employees;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _employees = ApiService().fetchEmployees();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  String formatPhone(String phone) {
    return phone.replaceAllMapped(
      RegExp(r'(\+55)?(\d{2})(\d{5})(\d{4})'),
      (Match m) => '(${m[2]}) ${m[3]}-${m[4]}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.person, color: Colors.white),
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 16),
            Text('Funcionários'),
            Spacer(),
            Icon(Icons.notifications, color: Colors.white),
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Text(
                "A",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Pesquisar",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Employee>>(
              future: _employees,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum funcionário encontrado.'));
                } else {
                  final employees = snapshot.data!
                      .where((employee) =>
                          employee.name.toLowerCase().contains(_searchQuery))
                      .toList();
                  return ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(employee.image),
                          ),
                          title: Text(employee.name),
                          subtitle: Text(employee.role),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cargo: ${employee.role}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      "Telefone: ${formatPhone(employee.phone)}"),
                                  SizedBox(height: 4),
                                  Text(
                                      "Admissão: ${formatDate(employee.admissionDate)}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
