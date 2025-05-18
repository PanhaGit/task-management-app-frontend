import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:get/get.dart';
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
      final data = _formKey.currentState!.value;
      final start = data['start_date'] as DateTime;
      final end = data['end_date'] as DateTime;

      final duration = end.difference(start);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;

      final color = (data['color'] as Color).value.toRadixString(16).padLeft(8, '0');

      final payload = {
        "title": data['title'],
        "description": data['description'],
        "start_date": start.toIso8601String(),
        "end_date": end.toIso8601String(),
        "category_id": data['category_id'],
        "hours": hours,
        "minutes": minutes,
        "color": "#$color",
      };

      final success = await _taskController.postNewTask(payload);
      if (success && mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back();
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
            "Add Project",
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
                        return _taskController.isLoading.value
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: _handleSubmit,
                          child: const Text("Submit Task"),
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
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Title',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              validator: FormBuilderValidators.required(errorText: 'Title is required'),
            ),
            const SizedBox(height: 20),
            FormBuilderTextField(
              name: 'description',
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Description',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              validator: FormBuilderValidators.required(errorText: 'Description is required'),
            ),
            const SizedBox(height: 20),
            FormBuilderDateTimePicker(
              name: "start_date",
              inputType: InputType.both,
              decoration: const InputDecoration(
                labelText: 'Start Date',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              validator: FormBuilderValidators.required(errorText: 'Start date is required'),
            ),
            const SizedBox(height: 20),
            FormBuilderDateTimePicker(
              name: "end_date",
              inputType: InputType.both,
              decoration: const InputDecoration(
                labelText: 'End Date',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              validator: FormBuilderValidators.required(errorText: 'End date is required'),
            ),
            const SizedBox(height: 20),
            FormBuilderDropdown<String>(
              name: 'category_id',
              decoration: const InputDecoration(
                labelText: 'Select Category',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              items: _taskController.categories
                  .map((cat) => DropdownMenuItem<String>(
                value: cat.id,
                child: Text(cat.title),
              ))
                  .toList(),
              validator: FormBuilderValidators.required(errorText: 'Please select a category'),
            ),
            const SizedBox(height: 20),
            // Custom color picker field:
            FormBuilderField<Color>(
              name: 'color',
              initialValue: Colors.blue,
              validator: FormBuilderValidators.required(errorText: 'Please choose a color'),
              builder: (FormFieldState<Color?> field) {
                return InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Choose Task Color',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      Color selectedColor = field.value ?? Colors.blue;

                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Pick a color'),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: selectedColor,
                                onColorChanged: (color) {
                                  selectedColor = color;
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  field.didChange(selectedColor);
                                },
                                child: const Text('Select'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      color: field.value ?? Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        field.value != null ? 'Color Selected' : 'Tap to pick a color',
                        style: TextStyle(
                          color: field.value != null ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
