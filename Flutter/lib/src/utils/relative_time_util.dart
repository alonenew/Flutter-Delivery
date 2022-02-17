import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class RelativeTimeUtil {
  static String getRelativeTime(int timestamp) {
    Intl.defaultLocale = "th";
    initializeDateFormatting();
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm dd/MM/yyyy');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    // var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = format.format(date);
    // if (diff.inSeconds <= 0 ||
    //     diff.inSeconds > 0 && diff.inMinutes == 0 ||
    //     diff.inMinutes > 0 && diff.inHours == 0 ||
    //     diff.inHours > 0 && diff.inDays == 0) {
    //   time = format.format(date);
    // } else if (diff.inDays > 0 && diff.inDays < 7) {
    //   if (diff.inDays == 1) {
    //     time = 'ทำ ' + diff.inDays.toString() + ' วัน';
    //   } else {
    //     time = 'ทำ ' + diff.inDays.toString() + ' วัน';
    //   }
    // } else {
    //   if (diff.inDays == 7) {
    //     time = 'ทำ ' + (diff.inDays / 7).floor().toString() + ' สัปดาห์';
    //   } else {
    //     time = 'ทำ ' + (diff.inDays / 7).floor().toString() + ' สัปดาห์';
    //   }
    // }
    return time;
  }
}
