import 'dart:convert';

import 'package:stackfood_multivendor/features/wallet/domain/models/fund_bonus_model.dart';

class RestaurantModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<Restaurant>? restaurants;

  RestaurantModel({this.totalSize, this.limit, this.offset, this.restaurants});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['restaurants'] != null) {
      restaurants = [];
      json['restaurants'].forEach((v) {
        restaurants!.add(Restaurant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (restaurants != null) {
      data['restaurants'] = restaurants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? logo;
  String? latitude;
  String? longitude;
  String? address;
  int? zoneId;
  double? minimumOrder;
  String? currency;
  bool? freeDelivery;
  String? coverPhoto;
  bool? delivery;
  bool? takeAway;
  bool? scheduleOrder;
  double? avgRating;
  double? tax;
  int? ratingCount;
  int? selfDeliverySystem;
  bool? posSystem;
  int? open;
  bool? active;
  String? deliveryTime;
  List<int>? categoryIds;
  int? veg;
  int? nonVeg;
  Discount? discount;
  List<Schedules>? schedules;
  double? minimumShippingCharge;
  double? perKmShippingCharge;
  double? maximumShippingCharge;
  int? vendorId;
  String? restaurantModel;
  int? restaurantStatus;
  RestaurantSubscription? restaurantSubscription;
  List<Cuisines>? cuisineNames;
  List<int>? cuisineIds;
  bool? orderSubscriptionActive;
  bool? cutlery;
  String? slug;
  int? foodsCount;
  List<Foods>? foods;
  bool? announcementActive;
  String? announcementMessage;
  bool? instantOrder;
  bool? customerDateOrderStatus;
  int? customerOrderDate;
  bool? freeDeliveryDistanceStatus;
  double? freeDeliveryDistanceValue;


  Restaurant(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.logo,
        this.latitude,
        this.longitude,
        this.address,
        this.zoneId,
        this.minimumOrder,
        this.currency,
        this.freeDelivery,
        this.coverPhoto,
        this.delivery,
        this.takeAway,
        this.scheduleOrder,
        this.avgRating,
        this.tax,
        this.ratingCount,
        this.selfDeliverySystem,
        this.posSystem,
        this.open,
        this.active,
        this.deliveryTime,
        this.categoryIds,
        this.veg,
        this.nonVeg,
        this.discount,
        this.schedules,
        this.minimumShippingCharge,
        this.perKmShippingCharge,
        this.maximumShippingCharge,
        this.vendorId,
        this.restaurantModel,
        this.restaurantStatus,
        this.restaurantSubscription,
        this.cuisineNames,
        this.cuisineIds,
        this.orderSubscriptionActive,
        this.cutlery,
        this.slug,
        this.foodsCount,
        this.foods,
        this.announcementActive,
        this.announcementMessage,
        this.instantOrder,
        this.customerDateOrderStatus,
        this.customerOrderDate,
        this.freeDeliveryDistanceStatus,
        this.freeDeliveryDistanceValue,
      });

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'] ?? '';
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    zoneId = json['zone_id'];
    minimumOrder = json['minimum_order'] != null ? json['minimum_order'].toDouble() : 0;
    currency = json['currency'];
    freeDelivery = json['free_delivery'];
    coverPhoto = json['cover_photo'] ?? '';
    delivery = json['delivery'];
    takeAway = json['take_away'];
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating']?.toDouble();
    tax = json['tax']?.toDouble();
    ratingCount = json['rating_count'];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    open = json['open'];
    active = json['active'];
    deliveryTime = json['delivery_time'];
    veg = json['veg'];
    nonVeg = json['non_veg'];
    categoryIds = json['category_ids'] != null ? json['category_ids'].cast<int>() : [];
    discount = json['discount'] != null ? Discount.fromJson(json['discount']) : null;
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules!.add(Schedules.fromJson(v));
      });
    }
    minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge'].toDouble() : 0.0;
    perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : 0.0;
    maximumShippingCharge = json['maximum_shipping_charge']?.toDouble();
    vendorId = json['vendor_id'];
    restaurantModel = json['restaurant_model'];
    restaurantStatus = json['restaurant_status'];
    restaurantSubscription = json['restaurant_sub'] != null ? RestaurantSubscription.fromJson(json['restaurant_sub']) : null;
    if(json['cuisine'] != null){
      cuisineNames = [];
      json['cuisine'].forEach((v){
        cuisineNames!.add(Cuisines.fromJson(v));
      });
    }
    orderSubscriptionActive = json['order_subscription_active'];
    // if(json['cuisine_ids'] != null){
    //   cuisineIds = [];
    //   json['cuisine_ids'].forEach((v){
    //     cuisineIds.add(v);
    //   });
    // }
    cutlery = json['cutlery'];
    slug = json['slug'];
    foodsCount = json['foods_count'];
    if (json['foods'] != null) {
      foods = <Foods>[];
      json['foods'].forEach((v) {
        foods!.add(Foods.fromJson(v));
      });
    }
    announcementActive = json['announcement'] == 1;
    announcementMessage = json['announcement_message'];
    instantOrder = json['instant_order'];
    customerDateOrderStatus = json['customer_date_order_sratus'];
    customerOrderDate = json['customer_order_date'];
    freeDeliveryDistanceStatus = json['free_delivery_distance_status'];
    freeDeliveryDistanceValue = (json['free_delivery_distance_value'] != null && json['free_delivery_distance_value'] != '') ? double.parse(json['free_delivery_distance_value'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['logo'] = logo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['minimum_order'] = minimumOrder;
    data['currency'] = currency;
    data['zone_id'] = zoneId;
    data['free_delivery'] = freeDelivery;
    data['cover_photo'] = coverPhoto;
    data['delivery'] = delivery;
    data['take_away'] = takeAway;
    data['schedule_order'] = scheduleOrder;
    data['avg_rating'] = avgRating;
    data['tax'] = tax;
    data['rating_count'] = ratingCount;
    data['self_delivery_system'] = selfDeliverySystem;
    data['pos_system'] = posSystem;
    data['open'] = open;
    data['active'] = active;
    data['veg'] = veg;
    data['non_veg'] = nonVeg;
    data['delivery_time'] = deliveryTime;
    data['category_ids'] = categoryIds;
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    if (schedules != null) {
      data['schedules'] = schedules!.map((v) => v.toJson()).toList();
    }
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    data['vendor_id'] = vendorId;
    data['cuisine'] = cuisineNames!.toList();
    data['order_subscription_active'] = orderSubscriptionActive;
    data['cutlery'] = cutlery;
    data['slug'] = slug;
    data['foods_count'] = foodsCount;
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    data['announcement'] = announcementActive;
    data['announcement_message'] = announcementMessage;
    data['instant_order'] = instantOrder;
    data['customer_date_order_sratus'] = customerDateOrderStatus;
    data['customer_order_date'] = customerOrderDate;
    data['free_delivery_distance_status'] = freeDeliveryDistanceStatus;
    data['free_delivery_distance_value'] = freeDeliveryDistanceValue;
    return data;
  }
}

class Discount {
  int? id;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  double? minPurchase;
  double? maxDiscount;
  double? discount;
  String? discountType;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;

  Discount(
      {this.id,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.minPurchase,
        this.maxDiscount,
        this.discount,
        this.discountType,
        this.restaurantId,
        this.createdAt,
        this.updatedAt});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time']?.substring(0, 5);
    endTime = json['end_time']?.substring(0, 5);
    minPurchase = json['min_purchase'].toDouble();
    maxDiscount = json['max_discount'].toDouble();
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['min_purchase'] = minPurchase;
    data['max_discount'] = maxDiscount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['restaurant_id'] = restaurantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Schedules {
  int? id;
  int? restaurantId;
  int? day;
  String? openingTime;
  String? closingTime;

  Schedules(
      {this.id,
        this.restaurantId,
        this.day,
        this.openingTime,
        this.closingTime});

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    day = json['day'];
    openingTime = json['opening_time'].substring(0, 5);
    closingTime = json['closing_time'].substring(0, 5);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurant_id'] = restaurantId;
    data['day'] = day;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    return data;
  }
}

class RestaurantSubscription {
  int? id;
  int? packageId;
  int? restaurantId;
  String? expiryDate;
  String? maxOrder;
  String? maxProduct;
  int? pos;
  int? mobileApp;
  int? chat;
  int? review;
  int? selfDelivery;
  int? status;
  int? totalPackageRenewed;
  String? createdAt;
  String? updatedAt;

  RestaurantSubscription(
      {this.id,
        this.packageId,
        this.restaurantId,
        this.expiryDate,
        this.maxOrder,
        this.maxProduct,
        this.pos,
        this.mobileApp,
        this.chat,
        this.review,
        this.selfDelivery,
        this.status,
        this.totalPackageRenewed,
        this.createdAt,
        this.updatedAt});

  RestaurantSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    restaurantId = json['restaurant_id'];
    expiryDate = json['expiry_date'];
    maxOrder = json['max_order'];
    maxProduct = json['max_product'];
    pos = json['pos'];
    mobileApp = json['mobile_app'];
    chat = (json['chat'] != null && json['chat'] != 'null') ? json['chat'] : 0;
    review = json['review'] ?? 0;
    selfDelivery = json['self_delivery'];
    status = json['status'];
    totalPackageRenewed = json['total_package_renewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['restaurant_id'] = restaurantId;
    data['expiry_date'] = expiryDate;
    data['max_order'] = maxOrder;
    data['max_product'] = maxProduct;
    data['pos'] = pos;
    data['mobile_app'] = mobileApp;
    data['chat'] = chat;
    data['review'] = review;
    data['self_delivery'] = selfDelivery;
    data['status'] = status;
    data['total_package_renewed'] = totalPackageRenewed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Refund {
  int? id;
  int? orderId;
  List<String>? image;
  String? customerReason;
  String? customerNote;
  String? adminNote;

  Refund(
      {this.id,
        this.orderId,
        this.image,
        this.customerReason,
        this.customerNote,
        this.adminNote,
      });

  Refund.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    if(json['image'] != null){
      image = [];
      jsonDecode(json['image']).forEach((v) => image!.add(v));
    }
    customerReason = json['customer_reason'];
    customerNote = json['customer_note'];
    adminNote = json['admin_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['image'] = image;
    data['customer_reason'] = customerReason;
    data['customer_note'] = customerNote;
    data['admin_note'] = adminNote;
    return data;
  }
}


class Foods {
  int? id;
  String? name;
  String? description;
  String? image;
  int? categoryId;
  String? categoryIds;
  String? variations;
  String? addOns;
  String? attributes;
  String? choiceOptions;
  double? price;
  double? tax;
  String? taxType;
  double? discount;
  String? discountType;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int? veg;
  int? status;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;
  int? orderCount;
  double? avgRating;
  int? ratingCount;
  String? rating;
  int? recommended;
  String? slug;
  int? maximumCartQuantity;
  List<Translations>? translations;

  Foods(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.categoryId,
        this.categoryIds,
        this.variations,
        this.addOns,
        this.attributes,
        this.choiceOptions,
        this.price,
        this.tax,
        this.taxType,
        this.discount,
        this.discountType,
        this.availableTimeStarts,
        this.availableTimeEnds,
        this.veg,
        this.status,
        this.restaurantId,
        this.createdAt,
        this.updatedAt,
        this.orderCount,
        this.avgRating,
        this.ratingCount,
        this.rating,
        this.recommended,
        this.slug,
        this.maximumCartQuantity,
        this.translations});

  Foods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    categoryId = json['category_id'];
    categoryIds = json['category_ids'];
    variations = json['variations'];
    addOns = json['add_ons'];
    attributes = json['attributes'];
    choiceOptions = json['choice_options'];
    price = json['price']?.toDouble();
    tax = json['tax']?.toDouble();
    taxType = json['tax_type'];
    discount = json['discount']?.toDouble();
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    veg = json['veg'];
    status = json['status'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderCount = json['order_count'];
    avgRating = json['avg_rating']?.toDouble();
    ratingCount = json['rating_count'];
    rating = json['rating'];
    recommended = json['recommended'];
    slug = json['slug'];
    maximumCartQuantity = json['maximum_cart_quantity'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['category_id'] = categoryId;
    data['category_ids'] = categoryIds;
    data['variations'] = variations;
    data['add_ons'] = addOns;
    data['attributes'] = attributes;
    data['choice_options'] = choiceOptions;
    data['price'] = price;
    data['tax'] = tax;
    data['tax_type'] = taxType;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['veg'] = veg;
    data['status'] = status;
    data['restaurant_id'] = restaurantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['order_count'] = orderCount;
    data['avg_rating'] = avgRating;
    data['rating_count'] = ratingCount;
    data['rating'] = rating;
    data['recommended'] = recommended;
    data['slug'] = slug;
    data['maximum_cart_quantity'] = maximumCartQuantity;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CuisineModel {
  List<Cuisines>? cuisines;

  CuisineModel({this.cuisines});

  CuisineModel.fromJson(Map<String, dynamic> json) {
    if (json['Cuisines'] != null) {
      cuisines = <Cuisines>[];
      json['Cuisines'].forEach((v) {
        cuisines!.add(Cuisines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cuisines != null) {
      data['Cuisines'] = cuisines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cuisines {
  int? id;
  String? name;
  String? image;
  int? status;
  String? slug;
  String? createdAt;
  String? updatedAt;

  Cuisines(
      {this.id,
        this.name,
        this.image,
        this.status,
        this.slug,
        this.createdAt,
        this.updatedAt});

  Cuisines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['status'] = status;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}