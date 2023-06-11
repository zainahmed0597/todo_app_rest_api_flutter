import 'package:flutter/material.dart';
import 'package:todo_app_rest_api_flutter/services/todo_services.dart';
import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;

  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
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
              isEdit ? updateData() : submitData();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // Edit the data from form
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];

    // Submit updated data to the server
    final isSuccess = await TodoService.updateTodo(id, body);
    // Show success or fail message based on status
    if (context.mounted) {
      if (isSuccess) {
        showSuccessMessage(context, message: 'Updated Success');
        Navigator.pop(context);
      } else {
        showErrorMessage(context, message: 'Creation Failed');
      }
    }
  }

  Future<void> submitData() async {
    // Submit data to the server
    final isSuccess = await TodoService.addTodo(body);

    // Show success or fail message based on status
    if (context.mounted) {
      if (isSuccess) {
        titleController.text = '';
        descriptionController.text = '';
        showSuccessMessage(context, message: 'Creation Success');
        Navigator.pop(context);
      } else {
        showErrorMessage(context, message: 'Creation Failed');

      }
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
