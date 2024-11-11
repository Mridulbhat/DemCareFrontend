import 'package:devcare_frontend/model/response/Todos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTodoDialog extends StatefulWidget {
  final Function(Todos) onSave;

  const AddTodoDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New To-Do"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
              validator: (value) => value!.isEmpty ? "Please enter a title" : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Select Date",
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              validator: (value) => _selectedDate == null ? "Please select a date" : null,
              controller: TextEditingController(
                text: _selectedDate == null ? '' : DateFormat.yMMMd().format(_selectedDate!),
              ),
            ),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Select Time",
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              validator: (value) => _selectedTime == null ? "Please select a time" : null,
              controller: TextEditingController(
                text: _selectedTime == null ? '' : _selectedTime!.format(context),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              DateTime scheduledFor = DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
                _selectedTime!.hour,
                _selectedTime!.minute,
              );

              print(scheduledFor.toIso8601String());
              Todos newTodo = Todos(
                title: _titleController.text,
                description: _descriptionController.text,
                scheduledFor: scheduledFor.toIso8601String(),
              );

              widget.onSave(newTodo);
              Navigator.of(context).pop();
            }
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
