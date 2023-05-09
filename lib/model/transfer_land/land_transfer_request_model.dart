// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

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
  String? landTransferId;
  File? pickedFile;
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
    this.landTransferId,
    this.pickedFile,
  });

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
      };
}
