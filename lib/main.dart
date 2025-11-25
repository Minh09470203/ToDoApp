import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'Model/items.dart';
import 'ModelButton.dart';
import 'cardbodywidget.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<DataItems> items = [];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Chuyển List<DataItems> thành JSON String
    List<Map<String, dynamic>> jsonList = items.map((item) {
      return {
        'id': item.id,
        'name': item.name,
        'isCompleted': item.isCompleted,
        'deadline': item.deadline?.toIso8601String(),
      };
    }).toList();

    String jsonString = jsonEncode(jsonList);
    await prefs.setString('tasks', jsonString);
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('tasks');

    if (jsonString != null && jsonString.isNotEmpty) {
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<DataItems> loadedItems = jsonList.map((jsonMap) {
        return DataItems(
          id: jsonMap['id'],
          name: jsonMap['name'],
          isCompleted: jsonMap['isCompleted'] ?? false, // Mặc định false nếu null
          deadline: jsonMap['deadline'] != null
              ? DateTime.parse(jsonMap['deadline'])
              : null,
        );
      }).toList();

      setState(() {
        items.clear();
        items.addAll(loadedItems);
      });
    }
  }

  void _handleAddTask(String name, DateTime? deadline) {
    final newItem = DataItems(
      id: DateTime.now().toString(),
      name: name,
      deadline: deadline,
    );
    setState(() {
      items.add(newItem);
    });
    _saveData();
  }

  void _handleDeleteTask(BuildContext context, DataItems item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                items.removeWhere((element) => element.id == item.id);
              });
              _saveData();
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleEditTask(BuildContext context, DataItems item) async {
    TextEditingController controller = TextEditingController(text: item.name);
    String? newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
    if (newName != null && newName.trim().isNotEmpty) {
      setState(() {
        item.name = newName.trim();
      });
      _saveData();
    }
  }

  void _handleCheckTask(BuildContext context, DataItems item) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Check task'),
        content: Text(
          item.isCompleted
              ? "Task is already checked"
              : 'Are you sure you want to check this task?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (!item.isCompleted) {
                  item.isCompleted = true;
                } else {
                  item.isCompleted = false;
                }
              });
              _saveData();
              Navigator.of(context).pop();
            },
            child: Text(item.isCompleted ? "Uncheck" : "Check"),
          ),
        ],
      ),
    );
  }

  void _handleViewDetail(BuildContext context, DataItems item) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(25),
          width: double.infinity,
          decoration: BoxDecoration(
            // Logic màu nền: Nếu DarkMode thì màu tối, LightMode thì trắng
            color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('Task Detail', style: GoogleFonts.lato(fontSize: 36, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black)),),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.event_note, size: 20, color: Colors.grey,),
                  SizedBox(width: 8,),
                  Text("Task name:", style: TextStyle(color: Colors.grey, fontSize: 24)),
                ],
              ),
              SizedBox(height: 5),
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height:10),
              // 2. Trạng thái
              Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.grey),
                  SizedBox(width: 8),
                  Text("Status: ", style: TextStyle(color: Colors.grey, fontSize: 24)),
                  Text(
                    item.isCompleted ? "Completed" : "Uncompleted",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: item.isCompleted ? Colors.green : Colors.redAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // 3. Deadline (Ngày hết hạn)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  SizedBox(width: 8),
                  Text("Deadline: ", style: TextStyle(color: Colors.grey, fontSize: 24)),
                  Text(
                    item.deadline != null
                        ? "${item.deadline!.day}/${item.deadline!.month}/${item.deadline!.year}"
                        : "No deadline",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: item.deadline != null ? (_isDarkMode ? Colors.white : Colors.black) : Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Nút Đóng
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text("Close", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              SizedBox(height: 10),
            ]
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context2) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 400),
            color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'ToDoList',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.lightBlueAccent,
                elevation: 0, // Remove default shadow
              ),
              body: Container(
                color: Colors.transparent, // Bright white background for the whole body
                child: Column(
                  children: [
                    // Shadow separator below AppBar
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: items.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox, size: 100, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    "Bạn rảnh rỗi quá! Hãy thêm việc đi",
                                    style: GoogleFonts.lato(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold)
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 30,
                              ),
                              child: Column(
                                children: items
                                    .map(
                                      (item) => Dismissible(
                                        key: Key(item.id),
                                        background: Container(
                                          color: Colors.red,
                                          child: Icon(Icons.delete),
                                          alignment: Alignment.centerRight,
                                        ),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (direction) async {
                                          // confirmDismiss được gọi khi người dùng vuốt
                                          return await showDialog(
                                            context: context2,
                                            builder: (context) => AlertDialog(
                                              title: Text('Delete Task'),
                                              content: Text(
                                                'Are you sure you want to delete this task?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        onDismissed: (direction) {
                                          setState(() {
                                            items.removeWhere(
                                              (element) => element.id == item.id,
                                            );
                                          });
                                          _saveData();
                                        },
                                        child: InkWell(
                                          child: CardBody(
                                            item: item,
                                            onDelete: (item) =>
                                                _handleDeleteTask(context2, item),
                                            onEdit: (item) =>
                                                _handleEditTask(context2, item),
                                            onCheck: (item) =>
                                                _handleCheckTask(context2, item),
                                          ),
                                          onTap: () => _handleViewDetail(context2, item),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        isScrollControlled: true,
                        context: context2,
                        builder: (BuildContext content) {
                          return ModelButton(addTask: _handleAddTask, isDarkMode: _isDarkMode);
                        },
                      );
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  SizedBox(height: 16),
                  FloatingActionButton(
                    onPressed: () => _toggleTheme(),
                    child: Icon(
                      _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      size: 30,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
