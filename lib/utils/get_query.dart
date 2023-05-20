import 'package:gis_flutter_frontend/core/development/console.dart';

String? getQuery(
  dynamic reqData, {
  String? sort,
  String? search,
}) {
  String fullquery = '?';
  if (reqData?.limit != null) {
    fullquery += "limit=${reqData?.limit}";
  } else {
    fullquery += "limit=5";
  }
  if (reqData?.page != null) {
    fullquery += "&page=${reqData?.page}";
  } else {
    fullquery += "&page=1";
  }
  if (sort != null) {
    fullquery += "&sort=$sort";
  }
  if (search != null) {
    fullquery += "&search=$search";
  }
  if (reqData?.latlng != null) {
    fullquery += "&latlng=${reqData?.latlng}";
  }
  if (reqData?.radius != null) {
    fullquery += "&radius=${reqData?.radius}";
  }
  if (reqData?.city != "" && reqData?.city != null) {
    fullquery += "&city=${reqData?.city}";
  }
  if (reqData?.district != "" && reqData?.district != null) {
    fullquery += "&district=${reqData?.district}";
  }
  if (reqData?.province != "" && reqData?.province != null) {
    fullquery += "&province=${reqData?.province}";
  }

  consolelog("fullquery :: $fullquery");

  return fullquery == '?' ? '' : fullquery;
}
