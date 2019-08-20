import 'package:intl/intl.dart';

String formatteddate(){

  var now= DateTime.now();
  var formatted= new DateFormat("EEE, MMM d, ''yy");

  String date=formatted.format(now);
  return date;
}