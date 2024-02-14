import 'package:stackfood_multivendor/features/language/domain/models/language_model.dart';
import 'package:flutter/material.dart';

abstract class LanguageServiceInterface {
  bool setLTR(Locale locale);
  updateHeader(Locale locale);
  Locale getLocaleFromSharedPref();
  setSelectedLanguageIndex(List<LanguageModel> languages, Locale locale);
  void saveLanguage(Locale locale);
}