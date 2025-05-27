import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/**
 * @author: Tho Panha
 * The Class for format Date
 * Function : DateFormatDOB()
 * */

class FormatDateHelper {
  /// Format Date of Birth: dd/MM/yyyy
  String formatDateDOB(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  /// Format Month and Year: "MMMM y" (e.g., "May 2025")
  String formatMonthAndYear(DateTime date) {
    final formatter = DateFormat('MMMM y', 'km_KH'); // Use Khmer if needed
    return formatter.format(date);
  }

  /// Format time: HH:mm (24-hour format)
  String formatTimeTask(DateTime time) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(time);
  }

  /// Simple format: dd/MM/yyyy
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format with day name: EEEE, dd MMM yyyy
  String formatFullDate(DateTime date) {
    return DateFormat('EEEE, dd MMM yyyy', 'km_KH').format(date);
  }
}