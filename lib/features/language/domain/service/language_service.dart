import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/language/domain/models/language_model.dart';
import 'package:stackfood_multivendor/features/language/domain/repository/language_repository_interface.dart';
import 'package:stackfood_multivendor/features/language/domain/service/language_service_interface.dart';
import 'package:flutter/material.dart';

class LanguageService implements LanguageServiceInterface {
  final LanguageRepositoryInterface languageRepositoryInterface;
  LanguageService({required this.languageRepositoryInterface});

  @override
  bool setLTR(Locale locale) {
    bool isLtr = true;
    if(locale.languageCode == 'ar') {
      isLtr = false;
    }else {
      isLtr = true;
    }
    return isLtr;
  }
  
  @override
  updateHeader(Locale locale) {
    AddressModel? addressModel = languageRepositoryInterface.getAddressFormSharedPref();
    languageRepositoryInterface.updateHeader(addressModel, locale);
  }

  @override
  Locale getLocaleFromSharedPref() {
    return languageRepositoryInterface.getLocaleFromSharedPref();
  }

  @override
  setSelectedLanguageIndex(List<LanguageModel> languages, Locale locale) {
    int selectedLanguageIndex = 0;
    for(int index = 0; index<languages.length; index++) {
      if(languages[index].languageCode == locale.languageCode) {
        selectedLanguageIndex = index;
        break;
      }
    }
    return selectedLanguageIndex;
  }

  @override
  void saveLanguage(Locale locale) {
    languageRepositoryInterface.saveLanguage(locale);
  }

}