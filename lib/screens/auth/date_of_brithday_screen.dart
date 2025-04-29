import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:frontend_app_task/constants/app_style.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/util/is_device_helper.dart';
import 'package:frontend_app_task/wiegtes/custome_button_wiegte.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_colors.dart';

class DateOfBrithdayScreen extends StatefulWidget {
  const DateOfBrithdayScreen({super.key});

  @override
  State<DateOfBrithdayScreen> createState() => _DateOfBrithdayScreenState();
}

class _DateOfBrithdayScreenState extends State<DateOfBrithdayScreen> {
  final IsDeviceHelper _isDeviceHelper = IsDeviceHelper();
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormBuilderState>();
  final _dateFormatter = DateFormat('dd/MM/yyyy');

  int get _age {
    final now = DateTime.now();
    return now.year - _selectedDate.year -
        (now.month > _selectedDate.month ||
            (now.month == _selectedDate.month && now.day >= _selectedDate.day) ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 8),
            child: _isDeviceHelper.isDevicesIosAndroidIcons(
              iconIos: const Icon(Icons.arrow_back, color: AppColors.black),
              iconAndroid: const Icon(Icons.arrow_back_ios, color: AppColors.black),
              onPressed: () => context.pushToSignup(),
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.white,
                    AppColors.lightBlue,
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(

                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - MediaQuery.of(context).padding.top,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 80.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              // Header Section
                              Text(
                                "What's your birthday?",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: AppColors.charcoalGray),
                                  children: [
                                    const TextSpan(
                                      text: "Choose your date of birthday. You can always make this private later. ",
                                    ),
                                    TextSpan(
                                      text: "Why do I need to provide my birthday?",
                                      style: TextStyle(color: AppColors.brightSkyBlue),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Form Section
                              FormBuilder(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: FormBuilderTextField(
                                        name: 'birthday',
                                        readOnly: true,
                                        initialValue: _dateFormatter.format(_selectedDate),
                                        decoration: InputDecoration(
                                          labelText: 'Birthday ($_age years old)',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: AppStyle.deviceHeight(context) * 0.03),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: CustomButtonWidget(
                                  backgroundColor: AppColors.brightSkyBlue,
                                  textColor: AppColors.white,
                                  buttonText: "Next",
                                  onPressed: () => _handleNextPressed(),
                                ).buildButton(),
                              ),
                            ],
                          ),
                        ),
                        // Date Picker Section
                        Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 20),
                          child: ScrollDatePicker(
                            selectedDate: _selectedDate,
                            locale: const Locale('en'),
                            maximumDate: DateTime.now(),
                            minimumDate: DateTime(1900),
                            options: const DatePickerOptions(
                              itemExtent: 40,
                              diameterRatio: 1.5,
                            ),
                            onDateTimeChanged: (DateTime value) {
                              setState(() {
                                _selectedDate = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleNextPressed() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Here you would typically save the date and navigate
      // For example: context.pushToNextScreen(_selectedDate);
      debugPrint('Selected date: ${_dateFormatter.format(_selectedDate)}');
    }
  }
}