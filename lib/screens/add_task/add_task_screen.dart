import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/controllers/task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TaskController _taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _taskController.fetchCategories();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final data = _formKey.currentState!.value;

        final title = data['title']?.toString() ?? '';
        if (title.isEmpty) throw Exception('Title is required');

        final start = data['start_date'] as DateTime;
        final end = data['end_date'] as DateTime;

        if (end.isBefore(start)) {
          throw Exception('End date must be after start date');
        }

        final categoryId = data['category_id'];
        final duration = end.difference(start);
        final hours = duration.inHours;
        final minutes = duration.inMinutes % 60;

        final payload = {
          "title": title,
          "description": data['description']?.toString() ?? '',
          "start_date": start.toUtc().toIso8601String(),
          "end_date": end.toUtc().toIso8601String(),
          "category_id": categoryId,
          "duration": {
            "hours": hours,
            "minutes": minutes,
          },
        };

        print("Submitting payload: $payload");

        final success = await _taskController.createTask(payload);
        if (success && mounted) {
          // Reset form and explicitly set fields to empty/default
          _formKey.currentState?.reset();
          _formKey.currentState?.patchValue({
            'title': '',
            'description': '',
            'start_date': DateTime.now(),
            'end_date': DateTime.now().add(const Duration(hours: 1)),
            'category_id': null,
          });

          // Show success feedback
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task created successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Delay navigation to allow UI to update
          await Future.delayed(const Duration(milliseconds: 500));
          Get.back(result: true);
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Create New Task",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: BackgroundGradient(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _addTaskForm(),
                      const SizedBox(height: 24),
                      Obx(() {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: ElevatedButton.icon(
                            onPressed: _taskController.isLoading.value
                                ? null
                                : _handleSubmit,
                            icon: _taskController.isLoading.value
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Icon(Icons.check, size: 20 , color: AppColors.white,),
                            label: Text(
                              _taskController.isLoading.value
                                  ? "Save..."
                                  : "Save Task",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brightSkyBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _addTaskForm() {
    return Obx(() {
      if (_taskController.isLoadingCategories.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF4A90E2)),
        );
      }

      if (_taskController.categories.isEmpty) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "No categories available",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        );
      }

      return Card(
        // color: AppColors.skyBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  name: 'title',
                  label: 'Task Title',
                  hint: 'Enter the task title',

                  icon: Icons.title,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  name: 'description',
                  label: 'Description',
                  hint: 'Enter the task description',
                  maxLines: 3,
                  icon: Icons.description,
                ),
                const SizedBox(height: 20),
                _buildDateTimePicker(
                  name: 'start_date',
                  label: 'Start Date & Time',
                  hint: 'Pick the start date and time',
                  initialValue: DateTime.now(),
                  icon: Icons.event,
                ),
                const SizedBox(height: 20),
                _buildDateTimePicker(
                  name: 'end_date',
                  label: 'End Date & Time',
                  hint: 'Pick the end date and time',
                  initialValue: DateTime.now().add(const Duration(hours: 1)),
                  icon: Icons.event_busy,
                ),
                const SizedBox(height: 20),
                _buildDropdown(
                  name: 'category_id',
                  label: 'Category',
                  hint: 'Select a category',
                  items: _taskController.categories
                      .map((cat) => DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.title),
                  ))
                      .toList(),
                  icon: Icons.category,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField({
    required String name,
    required String label,
    required String hint,
    int maxLines = 1,
    List<String? Function(String?)>? validator,
    required IconData icon,
  }) {
    return FormBuilderTextField(
      name: name,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.black87),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      validator: validator != null ? FormBuilderValidators.compose(validator) : null,
    );
  }

  Widget _buildDateTimePicker({
    required String name,
    required String label,
    required String hint,
    required DateTime initialValue,
    required IconData icon,
  }) {
    return FormBuilderDateTimePicker(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.black87),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      inputType: InputType.both,
      validator: FormBuilderValidators.required(),
      initialValue: initialValue,
    );
  }

  Widget _buildDropdown({
    required String name,
    required String label,
    required String hint,
    required List<DropdownMenuItem> items,
    required IconData icon,
  }) {
    return FormBuilderDropdown(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.black87),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      validator: FormBuilderValidators.required(),
      items: items,
    );
  }
}