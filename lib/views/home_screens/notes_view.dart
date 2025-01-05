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
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final userPreference = Provider.of<SharedPrefs>(context, listen: false);
    SpeechToText speechToText = SpeechToText();

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Icon(
              Icons.notifications,
              size: 35,
              color: Colors.grey.shade600,
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
                          'DIARY',
                          style: TextStyle(
                            color: Color(0xFF432C81),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Image.asset(
                          'assets/images/therapy.png',
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
                        onPressed: () {
                          // Fetch latest to-dos when the refresh button is pressed
                          viewModel.nullDisplayText();
                        },
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height *
                        0.45, // Limit max height
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height *
                                0.4, // Limit max height
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200, // Background color
                              borderRadius: BorderRadius.circular(
                                  12), // Circular border radius
                            ),
                            child: ListTile(
                              title: Text(
                                DateFormat('dd-MM-yyyy').format(
                                    DateTime.now()), // Display current date
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: SingleChildScrollView(
                                child: Text(
                                  viewModel
                                      .displayText, // Add your long description text
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height *
                              0.2, // Limit max height
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200, // Background color
                            borderRadius: BorderRadius.circular(
                                12), // Circular border radius
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    viewModel.recogText != ""
                                        ? viewModel.recogText
                                        : "Speak Now...",
                                    overflow: TextOverflow
                                        .ellipsis, // Ensures text is truncated if too long
                                    maxLines: 1, // Restricts to a single line
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      viewModel.setDisplaytext();
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      viewModel.setRecogText("");
                                    },
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: AvatarGlow(
          glowColor: Colors.blueGrey.shade100,
          animate: viewModel.animateMicButton,
          child: GestureDetector(
            onTapDown: (details) async {
              var available = await speechToText.initialize();
              if (available) {
                viewModel.setAnimateMicButton(true);
                speechToText.listen(onResult: (result) {
                  viewModel.setRecogText(result.recognizedWords);
                });
              }
              viewModel.setDisplaytext();
            },
            onTapUp: (details) {
              viewModel.setAnimateMicButton(false);
              speechToText.stop();
            },
            child: CircleAvatar(
              child: Icon(Icons.mic),
              radius: 35,
              backgroundColor: Colors.blueGrey.shade100,
            ),
          ),
        ),
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
