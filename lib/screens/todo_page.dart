import 'package:flutter/material.dart';
import 'package:todo_app_rest_api_flutter/screens/add_page.dart';
import 'package:todo_app_rest_api_flutter/services/todo_services.dart';
import '../utils/snackbar_helper.dart';
import '../widget/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  return TodoCard(
                    index: index,
                    deleteById: deleteById,
                    navigateEdit: navigateToEditPage,
                    item: item,
                  );
                }),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddPage();
        },
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    // delete the item
    final isSuccess = await TodoService.deleteById(id);
   if(context.mounted){
     if (isSuccess) {
       // remove the item form the list
       final filtered = items.where((element) => element['_id'] != id).toList();
       setState(() {
         items = filtered;
       });
     } else {
       // show error
       showErrorMessage(context, message: 'Deletion failed');
     }
   }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if(context.mounted){
      if (response != null) {
        setState(() {
          items = response;
        });
      } else {
        showErrorMessage(context, message: 'Something went wrong');
      }
      setState(() {
        isLoading = false;
      });
    }
  }


}
