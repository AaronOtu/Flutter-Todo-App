// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddList extends StatefulWidget {
  final Map? todo;
  const AddList({super.key, this.todo});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;

    titleController = TextEditingController(text: widget.todo?['title'] ?? '');
    descriptionController = TextEditingController(text: widget.todo?['description'] ?? '');
    }
  }

 @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Title'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(hintText: 'Description'),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 8,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              if (isEdit == true) {
                updateData();
              } else {
                submitData();
              }
            },
            child: Text(isEdit ? 'Update' : 'Submit'))
      ]),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }

    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      titleController.text = '';
      descriptionController.text = '';
      Navigator.pop(context,true);
      showSuccessMessage('Update successful');
    } else {
      showErrorMessage("Edit failed");
    }
  } 

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
       Navigator.pop(context,true);
      showSuccessMessage("Task created successfully");
    } else {
      showErrorMessage("Task creation failed");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: const TextStyle(color: Colors.green),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  
}
