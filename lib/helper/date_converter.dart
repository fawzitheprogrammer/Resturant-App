import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateConverter {

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss a').format(dateTime);
  }

  static String dateToTimeOnly(DateTime dateTime) {
    return DateFormat(_timeFormatter()).format(dateTime);
  }

  static String dateToDateAndTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
  static String dateToDateAndTimeAm(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd ${_timeFormatter()}').format(dateTime);
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('dd MMM, yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToTime(String dateTime) {
    return DateFormat('HH:mm a').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String stringToReadableString(String dateTime) {
    return DateFormat('dd MMMM, yyyy').format(DateTime.parse(dateTime).toLocal());
  }

  static String dateRangeToDate(DateTimeRange range) {
    return '${DateFormat('dd MMM, yyyy').format(range.start)} to ${DateFormat('dd MMM, yyyy').format(range.end)}';
  }

  static String stringDateTimeToDate(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
  }

  static String isoStringToLocalString(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(dateTime).toLocal());
  }

  static String isoStringToDateTimeString(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateTimeOnly(String dateTime) {
    return DateFormat('dd MMM yyyy HH:mm a').format(isoStringToLocalDate(dateTime));
  }

  static String dateTimeForCoupon(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String stringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String convertTimeToTime(String time) {
    return DateFormat(_timeFormatter()).format(DateFormat('HH:mm').parse(time));
  }

  static DateTime convertStringTimeToDate(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('${_timeFormatter()} | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static String dateToTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  static bool isAvailable(String? start, String? end, {DateTime? time, bool isoTime = false}) {
    DateTime currentTime;
    if(time != null) {
      currentTime = time;
    }else {
      currentTime = Get.find<SplashController>().currentTime;
    }
    DateTime start0 = start != null ? isoTime ? isoStringToLocalDate(start) : DateFormat('HH:mm').parse(start) : DateTime(currentTime.year);
    DateTime end0 = end != null ? isoTime ? isoStringToLocalDate(end) : DateFormat('HH:mm').parse(end) : DateTime(currentTime.year, currentTime.month, currentTime.day, 23, 59);
    DateTime startTime = DateTime(currentTime.year, currentTime.month, currentTime.day, start0.hour, start0.minute, start0.second);
    DateTime endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, end0.hour, end0.minute, end0.second);
    if(endTime.isBefore(startTime)) {
      if(currentTime.isBefore(startTime) && currentTime.isBefore(endTime)){
        startTime = startTime.add(const Duration(days: -1));
      }else {
        endTime = endTime.add(const Duration(days: 1));
      }
    }
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  static String _timeFormatter() {
    return Get.find<SplashController>().configModel!.timeformat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static int differenceInMinute(String? deliveryTime, String? orderTime, int? processingTime, String? scheduleAt) {
    // 'min', 'hours', 'days'
    int minTime = processingTime ?? 0;
    if(deliveryTime != null && deliveryTime.isNotEmpty && processingTime == null) {
      try {
        List<String> timeList = deliveryTime.split('-'); // ['15', '20']
        minTime = int.parse(timeList[0]);
      }catch(_) {}
    }
    DateTime deliveryTime0 = dateTimeStringToDate(scheduleAt ?? orderTime!).add(Duration(minutes: minTime));
    return deliveryTime0.difference(DateTime.now()).inMinutes;
  }

  static bool isBeforeTime(String? dateTime) {
    if(dateTime == null) {
      return false;
    }
    DateTime scheduleTime = dateTimeStringToDate(dateTime);
    return scheduleTime.isBefore(DateTime.now());
  }

  static int getWeekDaysCount(DateTimeRange range, List<int> weekdays) {
    int quantity = 0;
    DateTime startDate = range.start;
    for(int index=0; index<(range.duration.inDays+1); index++) {
      if((startDate.isBefore(range.end) || startDate.isAtSameMomentAs(range.end)) && weekdays.contains(startDate.weekday)) {
        quantity++;
      }
      if(startDate.isAfter(range.end)) {
        break;
      }
      startDate = startDate.add(const Duration(days: 1));
    }
    return quantity;
  }

  static int getMonthDaysCount(DateTimeRange range, List<int> days) {
    int quantity = 0;
    DateTime startDate = range.start;
    for(int index=0; index<(range.duration.inDays+1); index++) {
      if((startDate.isBefore(range.end) || startDate.isAtSameMomentAs(range.end)) && days.contains(startDate.day)) {
        quantity++;
      }
      if(startDate.isAfter(range.end)) {
        break;
      }
      startDate = startDate.add(const Duration(days: 1));
    }
    return quantity;
  }

  static String containTAndZToUTCFormat(String time) {
    var newTime = '${time.substring(0,10)} ${time.substring(11,23)}';
    return DateFormat('dd MMM, yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(newTime));

    // return DateFormat('${_timeFormatter()} | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static String convertOnlyTodayTime(String createdAt) {
    final now = DateTime.now();
    final createdAtDate = DateTime.parse(createdAt).toLocal();

    if (createdAtDate.year == now.year &&
        createdAtDate.month == now.month &&
        createdAtDate.day == now.day) {
      return DateFormat('h:mm a').format(createdAtDate);
    } else {
      return DateConverter.localDateToIsoStringAMPM(createdAtDate);
    }
  }

}
