
import 'package:stackfood_multivendor/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor/features/language/domain/models/language_model.dart';
import 'package:stackfood_multivendor/features/language/domain/service/language_service_interface.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController implements GetxService {
  final LanguageServiceInterface languageServiceInterface;
  LocalizationController({required this.languageServiceInterface}){
    loadCurrentLanguage();
  }

  // LocalizationController({required this.sharedPreferences, required this.apiClient}) {
  //   loadCurrentLanguage();
  // }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  Locale get locale => _locale;

  bool _isLtr = true;
  bool get isLtr => _isLtr;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  int _selectedLanguageIndex = 0;
  int get selectedLanguageIndex => _selectedLanguageIndex;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = languageServiceInterface.setLTR(_locale);
    languageServiceInterface.updateHeader(_locale);

    saveLanguage(_locale);
    if(AddressHelper.getAddressFromSharedPref() != null) {
      HomeScreen.loadData(true);
    }
    update();
  }

  void loadCurrentLanguage() async {
    _locale = languageServiceInterface.getLocaleFromSharedPref();
    _isLtr = _locale.languageCode != 'ar';
    _selectedLanguageIndex = languageServiceInterface.setSelectedLanguageIndex(AppConstants.languages, _locale);
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    languageServiceInterface.saveLanguage(locale);
  }

  void setSelectLanguageIndex(int index) {
    _selectedLanguageIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages  = [];
      _languages = AppConstants.languages;
    } else {
      _selectedLanguageIndex = -1;
      _languages = [];
      for (var language in AppConstants.languages) {
        if (language.languageName!.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      }
    }
    update();
  }

}