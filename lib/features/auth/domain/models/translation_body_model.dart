class TranslationBodyModel {
  int? id;
  String? locale;
  String? key;
  String? value;

  TranslationBodyModel({this.id, this.locale, this.key, this.value});

  TranslationBodyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}