import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RequestService {
  static Timestamp convertToTimestamp(DateTime date, String time) {
    DateTime dateTime;
    if (time == "5:30 PM") {
      dateTime = DateTime(date.year, date.month, date.day, 17, 30); // 5:30 PM
    } else if (time == "7:30 AM") {
      dateTime = DateTime(date.year, date.month, date.day, 7, 30); // 7:30 AM
    } else {
      return Timestamp.now(); // or handle an invalid time format as needed
    }

    return Timestamp.fromDate(dateTime);
  }

  static bool checkTimeFrom(DateTime date, String time) {
    // Combine the provided date and time strings into a single DateTime object
    DateTime combinedDateTime = DateTime(date.year, date.month, date.day)
        .add(Duration(hours: int.parse(time.split(':')[0]), minutes: int.parse(time.split(':')[1].split(' ')[0])))
        .add(time.split(' ')[1] == 'PM' ? Duration(hours: 12) : Duration.zero);

    // Get the current date and time
    DateTime now = DateTime.now();

    // Set the cutoff time for reservations (1:00 PM) and ride (5:30 PM) same day
    DateTime reservationCutoffTime = DateTime(now.year, now.month, now.day, 13, 0); // 1:00 PM same day
    // Check if the provided date and time are within the forbidden reservation windows for the same day
    if ((now.isAfter(reservationCutoffTime) && now.day == combinedDateTime.day)) {
      return false;
    }

    return true;
  }


  static bool checkTimeTo(DateTime date, String time) {
    // Combine the provided date and time strings into a single DateTime object
    DateTime combinedDateTime = DateTime(date.year, date.month, date.day)
        .add(Duration(hours: int.parse(time.split(':')[0]), minutes: int.parse(time.split(':')[1].split(' ')[0])))
        .add(time.split(' ')[1] == 'AM' ? Duration.zero : Duration(hours: 12)); // 7:30 AM

    // Get the current date and time
    DateTime now = DateTime.now();

    // Set the cutoff time to 10:00 PM the day before for comparison
    DateTime cutoffTime = DateTime(now.year, now.month, now.day, 22, 0); // 10:00 PM

    // Adjust the date to check the day before if the reservation is after 10 PM
    DateTime previousDayCutoff = now.subtract(Duration(days: 1)).add(Duration(hours: 22)); // 10:00 PM

    // Check if the provided date and time is after the current time,
    // before 10 PM the day before, and before 7:30 AM on the same day
    if ((now.isAfter(cutoffTime) && now.isBefore(combinedDateTime))||
        now.day == combinedDateTime.day) {
      return false;
    } else {
      return true;
    }
  }



}
