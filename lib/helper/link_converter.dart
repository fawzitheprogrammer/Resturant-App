import 'package:stackfood_multivendor/features/splash/domain/models/deep_link_body.dart';

class LinkConverter{

  static DeepLinkBody convertDeepLink(String link){
    List idx = link.split("/");
    String result = idx[3];
    List fi = result.split("?");

    String type = fi[0];
    List rawId = fi[1].split("=");

    String id = rawId[1];

    String? name;
    if(rawId.length > 2) {
      name = rawId[2];
    }

    if(id.contains('&')){
      List cat = id.split('&');
      id = cat[0];
    }
    DeepLinkType? t;
    if(type == 'restaurant'){
      t =  DeepLinkType.restaurant;
    }else if(type == 'cuisine-restaurant'){
      t = DeepLinkType.cuisine;
    }else if(type == 'category-product'){
      t = DeepLinkType.category;
    }
    return DeepLinkBody(deepLinkType: t, id: int.parse(id), name: name);
  }

}

