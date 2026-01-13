import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {
  final Student? student;

  const AddStudentScreen({super.key, this.student});


  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
  
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final DBHelper dbHelper = DBHelper();
@override
void initState() {
  super.initState();

  if (widget.student != null) {
    nameController.text = widget.student!.name;
    rollController.text = widget.student!.rollNo;
    courseController.text = widget.student!.course;
    emailController.text = widget.student!.email;
    phoneController.text = widget.student!.phone;
  }
}

  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field(nameController, "Name"),
              _field(rollController, "Roll No"),
              _field(courseController, "Course"),
              _field(emailController, "Email"),
              _field(phoneController, "Phone"),

              const SizedBox(height: 20),

             ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      if (widget.student == null) {
        // INSERT
        await dbHelper.insertStudent(
          Student(
            name: nameController.text,
            rollNo: rollController.text,
            course: courseController.text,
            email: emailController.text,
            phone: phoneController.text,
          ),
        );
      } else {
        // UPDATE
        await dbHelper.updateStudent(
          Student(
            id: widget.student!.id,
            name: nameController.text,
            rollNo: rollController.text,
            course: courseController.text,
            email: emailController.text,
            phone: phoneController.text,
          ),
        );
      }

      Navigator.pop(context, true);
    }
  },
  child: Text(widget.student == null ? "Save Student" : "Update Student"),
),

            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }
}
