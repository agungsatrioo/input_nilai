import 'package:intl/intl.dart';

String formatToTimeStamp(DateTime obj) =>
    DateFormat.yMMMMEEEEd("id").format(obj);

String formatTime(DateTime obj) => DateFormat("HH:mm").format(obj);
