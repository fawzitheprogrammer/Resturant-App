import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/distance_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/offline_method_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/timeslote_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/repositories/checkout_repository_interface.dart';
import 'package:stackfood_multivendor/features/checkout/domain/services/checkout_service_interface.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckoutService implements CheckoutServiceInterface {
  final CheckoutRepositoryInterface checkoutRepositoryInterface;
  CheckoutService({required this.checkoutRepositoryInterface});

  @override
  Future<int?> getDmTipMostTapped() async {
    return await checkoutRepositoryInterface.getDmTipMostTapped();
  }

  @override
  Future<List<OfflineMethodModel>> getOfflineMethodList() async {
    return await checkoutRepositoryInterface.getOfflineMethodList();
  }

  @override
  Future<double> getExtraCharge(double? distance) async {
    return await checkoutRepositoryInterface.getExtraCharge(distance);
  }

  @override
  List<TextEditingController> generateTextControllerList(List<MethodInformations>? methodInformation) {
    List<TextEditingController> informationControllerList = [];

    for(int index=0; index<methodInformation!.length; index++) {
      informationControllerList.add(TextEditingController());
    }
    return informationControllerList;
  }

  @override
  List<FocusNode> generateFocusList(List<MethodInformations>? methodInformation) {
    List<FocusNode> informationFocusList = [];

    for(int index=0; index<methodInformation!.length; index++) {
      informationFocusList.add(FocusNode());
    }
    return informationFocusList;
  }

  @override
  Future<List<TimeSlotModel>?> initializeTimeSlot(Restaurant restaurant, int? scheduleOrderSlotDuration) async {
    List<TimeSlotModel>? timeSlots = [];
    int minutes = 0;
    DateTime now = DateTime.now();
    for(int index=0; index<restaurant.schedules!.length; index++) {
      DateTime openTime = DateTime(
        now.year, now.month, now.day, DateConverter.convertStringTimeToDate(restaurant.schedules![index].openingTime!).hour,
        DateConverter.convertStringTimeToDate(restaurant.schedules![index].openingTime!).minute,
      );
      DateTime closeTime = DateTime(
        now.year, now.month, now.day, DateConverter.convertStringTimeToDate(restaurant.schedules![index].closingTime!).hour,
        DateConverter.convertStringTimeToDate(restaurant.schedules![index].closingTime!).minute,
      );
      if(closeTime.difference(openTime).isNegative) {
        minutes = openTime.difference(closeTime).inMinutes;
      }else {
        minutes = closeTime.difference(openTime).inMinutes;
      }
      if(minutes > scheduleOrderSlotDuration!) {
        DateTime time = openTime;
        for(;;) {
          if(time.isBefore(closeTime)) {
            DateTime start = time;
            DateTime end = start.add(Duration(minutes: scheduleOrderSlotDuration));
            if(end.isAfter(closeTime)) {
              end = closeTime;
            }
            timeSlots.add(TimeSlotModel(day: restaurant.schedules![index].day, startTime: start, endTime: end));
            time = time.add(Duration(minutes: scheduleOrderSlotDuration));
          }else {
            break;
          }
        }
      }else {
        timeSlots.add(TimeSlotModel(day: restaurant.schedules![index].day, startTime: openTime, endTime: closeTime));
      }
    }

    return timeSlots;
  }

  @override
  List<TimeSlotModel>? validateTimeSlot(List<TimeSlotModel> slots, DateTime date) {
    List<TimeSlotModel>? timeSlots = [];
    int day = 0;
    bool isToday = DateTime(date.year, date.month, date.day).isAtSameMomentAs(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );
    day = date.weekday;

    if(day == 7) {
      day = 0;
    }
    for(int index=0; index<slots.length; index++) {
      if (day == slots[index].day && (isToday ? slots[index].endTime!.isAfter(DateTime.now()) : true)) {
        timeSlots.add(slots[index]);
      }
    }
    return timeSlots;
  }

  @override
  List<int>? validateSlotIndexes(List<TimeSlotModel> slots, DateTime date) {
    List<int>? slotIndexList = [];
    int day = 0;
    bool isToday = DateTime(date.year, date.month, date.day).isAtSameMomentAs(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );
    day = date.weekday;

    if(day == 7) {
      day = 0;
    }

    int index0 = 0;
    for(int index=0; index<slots.length; index++) {
      if (day == slots[index].day && (isToday ? slots[index].endTime!.isAfter(DateTime.now()) : true)) {
        slotIndexList.add(index0);
        index0 ++;
      }
    }
    return slotIndexList;
  }

  @override
  Future<bool> saveOfflineInfo(String data) async {
    return await checkoutRepositoryInterface.saveOfflineInfo(data);
  }

  @override
  int selectInstruction(int index, int selected){
    int selectedInstruction = selected;
    if(selectedInstruction == index){
      selectedInstruction = -1;
    }else {
      selectedInstruction = index;
    }
    return selectedInstruction;
  }

  @override
  Future<Response> placeOrder(PlaceOrderBodyModel orderBody) async {
    return await checkoutRepositoryInterface.placeOrder(orderBody);
  }

  @override
  Future<Response> sendNotificationRequest(String orderId, String? guestId) async {
    return await checkoutRepositoryInterface.sendNotificationRequest(orderId, guestId);
  }

  @override
  String setPreferenceTimeForView(String time, bool instanceOrder){
    String preferableTime = '';
    if(instanceOrder) {
      preferableTime = time;
    }else {
      preferableTime = '';
    }
    return preferableTime;
  }

  @override
  int selectTimeSlot(bool instanceOrder) {
    int selectedTimeSlot = 0;
    if(instanceOrder) {
      selectedTimeSlot = 0;
    } else {
      selectedTimeSlot = 1;
    }
    return selectedTimeSlot;
  }

  @override
  double updateTips(int index, int selectedTips) {
    double tips = 0;
    if(selectedTips == 0 || selectedTips == AppConstants.tips.length -1) {
      tips = 0;
    }else{
      tips = double.parse(AppConstants.tips[index]);
    }
    return tips;
  }

  @override
  Future<double?> getDistanceInKM(LatLng originLatLng, LatLng destinationLatLng, {bool isDuration = false}) async {
    double distance = -1;
    Response response = await checkoutRepositoryInterface.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        if(isDuration){
          distance = DistanceModel.fromJson(response.body).rows![0].elements![0].duration!.value! / 3600;
        }else{
          distance = DistanceModel.fromJson(response.body).rows![0].elements![0].distance!.value! / 1000;
        }
      } else {
        if(!isDuration) {
          distance = Geolocator.distanceBetween(
            originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
          ) / 1000;
        }
      }
    } catch (e) {
      if(!isDuration) {
        distance = Geolocator.distanceBetween(originLatLng.latitude, originLatLng.longitude,
            destinationLatLng.latitude, destinationLatLng.longitude) / 1000;
      }
    }

    return distance;
  }

  @override
  Future<bool> updateOfflineInfo(String data) async {
    return await checkoutRepositoryInterface.updateOfflineInfo(data);
  }

}