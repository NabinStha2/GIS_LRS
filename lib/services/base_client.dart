import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gis_flutter_frontend/utils/text_capitalization.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/development/console.dart';
import '../utils/app_shared_preferences.dart';
import 'api_exceptions.dart';

class BaseClient {
  static const int timeOutDuration = 20;
  var client = http.Client();

  final Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  //DELETE
  Future<dynamic> delete(String baseUrl, String api,
      {bool hasTokenHeader = true, dynamic payloadObj}) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(payloadObj ?? {});
    try {
      var response = await http
          .delete(
            uri,
            body: payload,
            headers: hasTokenHeader
                ? {
                    HttpHeaders.authorizationHeader:
                        "Bearer ${AppSharedPreferences.getAuthToken}",
                    'Content-type': 'application/json',
                    'Accept': 'application/json'
                  }
                : _headers,
          )
          .timeout(const Duration(seconds: timeOutDuration));

      consolelog(uri);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Something went wrong, Try again', uri.toString());
    }
  }

  //GET
  Future<dynamic> get(String baseUrl, String api,
      {bool hasTokenHeader = true}) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await http
          .get(
            uri,
            headers: hasTokenHeader
                ? {
                    HttpHeaders.authorizationHeader:
                        "Bearer ${AppSharedPreferences.getAuthToken}",
                    'Content-type': 'application/json',
                    'Accept': 'application/json'
                  }
                : _headers,
          )
          .timeout(const Duration(seconds: timeOutDuration));

      consolelog(uri);
      // consolelog(response);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Something went wrong, Try again', uri.toString());
    }
  }

//PATCH
  Future<dynamic> patch(String baseUrl, String api, Map payloadObj,
      {bool hasTokenHeader = true}) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(payloadObj);

    try {
      var response = await http
          .patch(
            uri,
            body: payload,
            headers: hasTokenHeader
                ? {
                    HttpHeaders.authorizationHeader:
                        "Bearer ${AppSharedPreferences.getAuthToken}",
                    'Content-type': 'application/json',
                    'Accept': 'application/json'
                  }
                : _headers,
          )
          .timeout(const Duration(seconds: timeOutDuration));

      consolelog(uri);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responding in time', uri.toString());
    }
  }

//POST
  Future<dynamic> post(String baseUrl, String api, dynamic payloadObj,
      {bool hasTokenHeader = true}) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(payloadObj);

    try {
      var response = await http
          .post(
            uri,
            body: payload,
            headers: hasTokenHeader
                ? {
                    HttpHeaders.authorizationHeader:
                        "Bearer ${AppSharedPreferences.getAuthToken}",
                    'Content-type': 'application/json',
                    'Accept': 'application/json'
                  }
                : _headers,
          )
          .timeout(const Duration(seconds: timeOutDuration));

      consolelog(uri);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //file
  // Future<dynamic> postWithFile(
  //   String baseUrl,
  //   String api,
  //   Map<String, String> payloadObj, {
  //   File? file,
  //   String method = 'POST',
  //   String? imageKey,
  //   Map<String, String>? header,
  // }) async {
  //   var uri = Uri.parse(
  //     baseUrl + api,
  //   );
  //   try {
  //     var request = http.MultipartRequest(method, uri);
  //     request.headers.addAll(header ?? _headers);

  //     if (file != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           "$imageKey",
  //           file.path,
  //           contentType: MediaType(
  //             UserController.instance.pickedFile?.extension?.contains('pdf') ==
  //                     true
  //                 ? 'application'
  //                 : 'image',
  //             UserController.instance.pickedFile?.extension?.contains('pdf') ==
  //                     true
  //                 ? 'pdf'
  //                 : 'jpg',
  //           ),
  //         ),
  //       );
  //     }
  //     request.fields.addAll(payloadObj);
  //     var data = await request.send();
  //     var response =
  //         await http.Response.fromStream(data).timeout(const Duration(
  //       seconds: timeOutDuration,
  //     ));

  //     return _processResponse(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection', uri.toString());
  //   } on TimeoutException {
  //     throw ApiNotRespondingException(
  //         'Something went wrong, Try again', uri.toString());
  //   }
  // }

  Future<dynamic> postWithImage(String baseUrl, String api,
      {Map<String, String>? payloadObj,
      List<File>? imgFiles,
      File? file,
      Uint8List? uint8File,
      String method = 'POST',
      String? imageKey,
      bool hasTokenHeader = true}) async {
    var uri = Uri.parse(
      baseUrl + api,
    );
    try {
      var request = http.MultipartRequest(method, uri);
      request.headers.addAll(hasTokenHeader
          ? {
              HttpHeaders.authorizationHeader:
                  "Bearer ${AppSharedPreferences.getAuthToken}",
              'Content-type': 'application/json',
              'Accept': 'application/json'
            }
          : _headers);

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "$imageKey",
            file.path,
            contentType: MediaType(
              'image',
              'jpg',
            ),
          ),
        );
      }
      // if (file != null) {
      //   request.files.add(
      //     await http.MultipartFile.fromPath(
      //       "$imageKey",
      //       file.path,
      //       contentType: MediaType(
      //         'image',
      //         'jpg',
      //       ),
      //     ),
      //   );
      // }
      if (uint8File != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "$imageKey",
            uint8File,
            contentType: MediaType(
              'image',
              'jpg',
            ),
          ),
        );
      }
      if (imgFiles?.isNotEmpty == true) {
        for (var i = 0; i < imgFiles!.length; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "$imageKey",
              imgFiles[i].path,
              contentType: MediaType(
                'image',
                'jpg',
              ),
            ),
          );
        }
      }

      request.fields.addAll(payloadObj ?? <String, String>{});
      var data = await request.send();
      var response = await http.Response.fromStream(data);

      consolelog(uri);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Something went wrong, Try again', uri.toString());
    }
  }

  Future<dynamic> put(String baseUrl, String api, dynamic payloadObj,
      {bool hasTokenHeader = true}) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(payloadObj);
    try {
      var response = await http
          .put(
            uri,
            body: payload,
            headers: hasTokenHeader
                ? {
                    HttpHeaders.authorizationHeader:
                        "Bearer ${AppSharedPreferences.getAuthToken}",
                    'Content-type': 'application/json',
                    'Accept': 'application/json'
                  }
                : _headers,
          )
          .timeout(const Duration(seconds: timeOutDuration));

      consolelog(uri);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Something went wrong, Try again', uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    consolelog("Processing response: ${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(
            (json.decode(response.body)["error"] ?? "Something went wrong")
                .toString()
                .toCapitalized(),
            response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            json.decode(response.body)["error"] ?? "Something went wrong",
            response.request!.url.toString());
      case 422:
        throw ApiNotRespondingException(
            json.decode(response.body)["error"] ?? "Something went wrong",
            response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException(
          json.decode(response.body)["error"] ??
              'Server cannot handled this error',
          response.request?.url.toString(),
        );
    }
  }
}
