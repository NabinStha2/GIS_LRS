// ignore_for_file: public_member_api_docs, sort_constructors_first
class LandRequestModel {
  int? page;
  int? limit;
  String? search;
  String? city;
  String? district;
  String? province;
  String? landId;
  String? landSaleId;
  String? latlng;
  double? radius;
  String? registrationIdToken;
  String? parcelId;
  String? image;
  LandRequestModel({
    this.page,
    this.limit,
    this.search,
    this.city,
    this.district,
    this.province,
    this.landId,
    this.landSaleId,
    this.latlng,
    this.radius,
    this.registrationIdToken,
    this.parcelId,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
      };
}
