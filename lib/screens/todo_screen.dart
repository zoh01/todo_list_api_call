import 'package:flutter/material.dart';
import 'package:todo_api/widet/todo_card.dart';

import '../services/todo_service.dart';
import '../utils/snackbar_helper.dart';
import 'edit_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
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
        title: const Text(
          'Todo List',
          style: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add Todo'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text(
                'No Todo Item...',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'];
                  return TodoCard(
                    index: index,
                    item: item,
                    navigateToEditPage: navigateToEditPage,
                    deleteById: deleteById,
                  );
                }),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Navigate to edit page
  Future<void> navigateToEditPage(Map item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTodoScreen(todo: item),
      ),
    );
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  /// Navigate to Add new list page
  Future<void> navigateToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditTodoScreen(),
      ),
    );
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  /// Delete by Id list
  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      // Remove the item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // Show error
      showErrorMessage(context, message: 'Something went wrong');
    }
  }

  /// Get all data saved on the server
  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
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
