import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelButton extends StatefulWidget {

  ModelButton({
    super.key, required this.addTask, this.isDarkMode = false
  });
  final Function addTask;
  bool isDarkMode;
  @override
  State<ModelButton> createState() => _ModelButtonState();
}

class _ModelButtonState extends State<ModelButton> {
  String textValue = '';
  DateTime? _selectedDate;

  void _handleOnclick(BuildContext context) {
    final name = textValue;
    if (name.isEmpty) {
      return;
    }
    widget.addTask(name, _selectedDate);

    Navigator.pop(context);
  }

  void _presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.lightBlueAccent.withOpacity(0.05),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 18),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'Enter Task Name',
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                ),
                onChanged: (text) {
                  textValue = text;
                },
                style: TextStyle(fontSize: 18, color: Color(0xFF4B4B4B)),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter Deadline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _presentDatePicker(context),
                    icon: Icon(Icons.calendar_today_rounded),
                    iconSize: 30,
                    color: _selectedDate != null ? Colors.blue : Colors.grey, // Xanh nếu đã chọn
                  ),
                ],
              ),
              SizedBox(height: 18,),
              ElevatedButton(
                onPressed: () => _handleOnclick(context),
                child: Text(
                  'Add Task',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  shadowColor: Colors.lightBlueAccent.withOpacity(0.18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
