import 'package:devcare_frontend/data/response/api_response.dart';
import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/model/response/GetAllTodoResponse.dart';
import 'package:devcare_frontend/model/response/Todos.dart';
import 'package:devcare_frontend/res/addTodoDialog.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/home_screens/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final userPreference = Provider.of<SharedPrefs>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Icon(
            Icons.notifications,
            size: 35,
            color: Colors.grey.shade600,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: CircleAvatar(
              child: Image.asset(
                'assets/images/avatar.png',
                height: 390,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 116,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: ListTile(
                        title: const Text(
                          'TO-DO LIST',
                          style: TextStyle(
                            color: Color(0xFF432C81),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Image.asset(
                          'assets/images/todo.png',
                          height: 60,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFDFB300),
                      ),
                      ElevatedButton(
                        child: Icon(Icons.refresh_rounded),
                        onPressed: () async {
                          // Fetch latest to-dos when the refresh button is pressed
                          await viewModel.fetchUserTodos(userPreference);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: (viewModel.getAllTodoResponse.status == Status.PRECALL)
                      ? FutureBuilder<ApiResponse<GetAllTodoResponse>>(
                          future: viewModel.fetchUserTodos(userPreference),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  height: 100,
                                  width: 100,
                                  child: const CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Text("Error fetching to-dos");
                            } else if (!snapshot.hasData ||
                                snapshot.data!.data!.todos!.isEmpty) {
                              return const Text("No todos available");
                            }

                            return buildTodoList(viewModel, userPreference);
                          },
                        )
                      : buildTodoList(viewModel, userPreference),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTodoDialog(
                onSave: (newTodo) async {
                  await viewModel.addTodo(newTodo, userPreference);
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey.shade100,
      ),
    );
  }

  // Extracted method to build the list of to-dos
  Widget buildTodoList(HomeViewModel viewModel, SharedPrefs userPreference) {
    return ListView.builder(
      itemCount: viewModel.groupedTodos.keys.length,
      itemBuilder: (context, index) {
        String date = viewModel.groupedTodos.keys.elementAt(index);
        List<Todos> todos = viewModel.groupedTodos[date] ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ...todos.map((todo) => Card(
                    elevation: 2,
                    child: ListTile(
                      onTap: () async {
                        if (!todo.isDone!) {
                          bool confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Are you sure?"),
                              content: Text(
                                  "Do you want to mark this item as Done?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text("Yes"),
                                ),
                              ],
                            ),
                          );

                          if (confirm) {
                            viewModel.toggleTodoStatus(todo, userPreference);
                          }
                        }
                      },
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.alarm_rounded,
                            size: 18,
                          ),
                          Text(DateFormat.jm().format(
                              DateTime.parse(todo.scheduledFor.toString())
                                  .add(Duration(hours: 5, minutes: 30))))
                        ],
                      ),
                      title: Text(todo.title ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: todo.isDone ?? false
                                ? Colors.grey
                                : Colors.black,
                            decoration: todo.isDone ?? false
                                ? TextDecoration.lineThrough
                                : null,
                          )),
                      subtitle: Text(todo.description ?? "No description"),
                      trailing: Icon(
                        todo.isDone ?? false
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color:
                            todo.isDone ?? false ? Colors.green : Colors.grey,
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
