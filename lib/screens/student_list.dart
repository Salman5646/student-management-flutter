import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../db/db_helper.dart';
import '../models/student.dart';
import 'add_student.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final DBHelper dbHelper = DBHelper();
  final searchController = TextEditingController();
  late Future<List<Student>> students;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    students = dbHelper.getStudents();
    setState(() {});
  }

  Future<void> callStudent(String phone) async {
    launchUrl(Uri(scheme: 'tel', path: phone));
  }

  Future<void> mailStudent(String email) async {
    launchUrl(Uri(scheme: 'mailto', path: email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Management')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  students = value.isEmpty
                      ? dbHelper.getStudents()
                      : dbHelper.searchStudents(value);
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Student>>(
              future: students,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No students found'),
                  );
                }

                return ListView(
                  children: snapshot.data!.map((student) {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(student.name[0].toUpperCase()),
                        ),
                        title: Text(student.name),
                        subtitle: Text(
                          'Roll: ${student.rollNo}\nCourse: ${student.course}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'call') callStudent(student.phone);
                            if (value == 'mail') mailStudent(student.email);
                            if (value == 'edit') {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddStudentScreen(student: student),
                                ),
                              );
                              if (res == true) refresh();
                            }
                            if (value == 'delete') {
                              await dbHelper.deleteStudent(student.id!);
                              refresh();
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'call', child: Text('Call')),
                            PopupMenuItem(value: 'mail', child: Text('Email')),
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
          );
          if (res == true) refresh();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Student"),
      ),
    );
  }
}
