class LandTransferRequestModel {
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
  LandTransferRequestModel({
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
  });

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
      };
}
