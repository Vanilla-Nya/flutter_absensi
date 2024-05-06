class RegisterWidgetModel {
  RegisterWidgetModel({
    this.expansionCallback,
    required this.data,
  });
  final Function(int, bool)? expansionCallback;
  final List<Map<String, dynamic>> data;
}
