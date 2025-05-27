import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend_app_task/models/Categories.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/controllers/task_controller.dart';
import 'package:frontend_app_task/constants/app_colors.dart';

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
          _formKey.currentState?.reset();
          Get.back(result: true);
        }
      } catch (e) {
        print(e);
        // Handle error (show snackbar or other UI feedback)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Center(
          child: Text(
            "Create New Task",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BackgroundGradient(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _addTaskForm(),
                      const SizedBox(height: 24),
                      Obx(() {
                        return ElevatedButton.icon(
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
                              : const Icon(Icons.check),
                          label: const Text("Submit Task"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brightSkyBlue,
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _addTaskForm() {
    return Obx(() {
      if (_taskController.isLoadingCategories.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_taskController.categories.isEmpty) {
        return const Text("No categories available");
      }

      return FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'title',
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                helperText: 'Enter the task title',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(100),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'description',
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                helperText: 'Enter the task description',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(500),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderDateTimePicker(
              name: 'start_date',
              decoration: const InputDecoration(
                labelText: 'Start Date',
                border: OutlineInputBorder(),
                helperText: 'Pick the date and time the task starts',
              ),
              inputType: InputType.both,
              validator: FormBuilderValidators.required(),
              initialValue: DateTime.now(),
            ),
            const SizedBox(height: 16),
            FormBuilderDateTimePicker(
              name: 'end_date',
              decoration: const InputDecoration(
                labelText: 'End Date',
                border: OutlineInputBorder(),
                helperText: 'Pick the date and time the task ends',
              ),
              inputType: InputType.both,
              validator: FormBuilderValidators.required(),
              initialValue: DateTime.now().add(const Duration(hours: 1)),
            ),
            const SizedBox(height: 16),
            // 👇 Add this dropdown for category selection
            FormBuilderDropdown(
              name: 'category_id',
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                helperText: 'Select a category for the task',
              ),
              validator: FormBuilderValidators.required(),
              items: _taskController.categories
                  .map((cat) => DropdownMenuItem(
                value: cat.id,
                child: Text(cat.title),
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}
