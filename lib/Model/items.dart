class DataItems {
  final String id;
  String name;
  bool isCompleted;
  DateTime? deadline;

  DataItems({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.deadline,
  });
}
