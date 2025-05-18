/// Flutter data model for parsing the task response from JSON
///
/// @author Tho Panha

class TaskResponse {
  final bool success;
  final List<Task> data;
  final String message;

  TaskResponse({required this.success, required this.data, required this.message});

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      success: json['success'],
      data: List<Task>.from(json['data'].map((task) => Task.fromJson(task))),
      message: json['message'],
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final int hours;
  final int minutes;
  final CreatedBy createdBy;
  final Category category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.hours,
    required this.minutes,
    required this.createdBy,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      hours: json['hours'],
      minutes: json['minutes'],
      createdBy: CreatedBy.fromJson(json['created_by']),
      category: Category.fromJson(json['category_id']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Factory constructor for an empty Task instance
  factory Task.empty() {
    return Task(
      id: '',
      title: '',
      description: '',
      status: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      hours: 0,
      minutes: 0,
      createdBy: CreatedBy.empty(),
      category: Category.empty(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class CreatedBy {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;

  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
    );
  }

  /// Factory constructor for an empty CreatedBy instance
  factory CreatedBy.empty() {
    return CreatedBy(
      id: '',
      firstName: '',
      lastName: '',
      phoneNumber: '',
      email: '',
    );
  }
}

class Category {
  final String id;
  final String title;

  Category({required this.id, required this.title});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      title: json['title'],
    );
  }

  /// Factory constructor for an empty Category instance
  factory Category.empty() {
    return Category(
      id: '',
      title: '',
    );
  }
}
