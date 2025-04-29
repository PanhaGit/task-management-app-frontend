import 'package:intl/intl.dart';


/**
 * @author: Tho Panha
 * The Class for format Date
 * Function : DateFormatDOB()
 * */

class FormatDateHelper {

  //  'dd/MM/yyyy' format
  Future<String> dateFormatDOB(DateTime date) async {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  // Future<String> dateFormatTime(DateTime time) async{
  //   final DateFormat formatter = DateFormat('');
  //   return formatter.format(time);
  // }
}
