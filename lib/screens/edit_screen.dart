import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/services/todo_service.dart';

import '../utils/snackbar_helper.dart';

class EditTodoScreen extends StatefulWidget {
  final Map? todo;

  const EditTodoScreen({
    super.key,
    this.todo,
  });

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      // Prefill Edit form
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
          style: const TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Title',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(
              height: 14,
            ),
            TextFormField(
              controller: titleController,
              keyboardType: TextInputType.multiline,
              cursorColor: Colors.black38,
              style: const TextStyle(),
              maxLines: null,
              decoration: const InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Description',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(
              height: 14,
            ),
            TextFormField(
              controller: descController,
              keyboardType: TextInputType.multiline,
              cursorColor: Colors.black38,
              style: const TextStyle(),
              minLines: 2,
              maxLines: null,
              decoration: const InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isEdit ? updateData : submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  textStyle: const TextStyle(fontSize: 28),
                  minimumSize: const Size(0, 60),
                ),
                child: Text(
                  isEdit ? 'Update' : 'Submit',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    /// Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];

    /// Submit update to the server
    final isSuccess = await TodoService.updateTodo(id, body);

    /// show success or failed messages based on status
    if (isSuccess) {
      showSuccessMessage(context, message: 'Updating Success');
    } else {
      print('Creation failed');
      showErrorMessage(context, message: 'Updating Failed');
    }
  }

  Future<void> submitData() async {
    /// Submit data to the server
    final isSuccess = await TodoService.addTodo(body);

    /// show success or failed messages based on status
    if (isSuccess) {
      titleController.text = '';
      descController.text = '';
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Map get body {
    /// Get the data from form
    final title = titleController.text;
    final description = descController.text;

    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
