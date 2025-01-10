import 'dart:convert';

import 'package:energy_app/api/models/energy_point.dart';
import 'package:energy_app/utils/util.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

const String API_ENDPOINT = '192.168.178.34:3000';

typedef ApiResponse = http.Response;

class ApiRequestWrapper<T> {
  Future<ApiResponse> Function() request;
  T Function(ApiResponse)? decoder;
  T? value;
  List<int> expectedStatusCodes;
  Exception? exception;

  ApiRequestWrapper(
      {required this.request,
      this.decoder,
      this.expectedStatusCodes = const [200]});

  Future<ApiResponseWrapper<T>> execute() async {
    try {
      ApiResponse response = await request();
      if (!expectedStatusCodes.contains(response.statusCode)) {
        throw UnexpectedStatusCodeException(
            response.statusCode, response.request!.url,
            response: response);
      }
      if (decoder != null) {
        value = decoder!(response);
      }
      return ApiResponseWrapper(response: response, value: value);
    } catch (ex) {
      return ApiResponseWrapper(
        exception: ex is Exception ? ex : Exception(ex.toString()),
      );
    }
  }
}

class ApiResponseWrapper<T> {
  ApiResponse? response;
  T? value;
  Exception? exception;

  ApiResponseWrapper({this.response, this.value, this.exception});
}

class UnexpectedStatusCodeException implements Exception {
  final int statusCode;
  final Uri uri;
  ApiResponse? response;

  UnexpectedStatusCodeException(this.statusCode, this.uri, {this.response});
  @override
  String toString() => statusCode.toString();
}

@Singleton()
class Api {
  late Function(String) showErrorMessage;
  Api();

  Uri getApiUri(String path, Map<String, dynamic>? queryParams) {
    return Uri.http(API_ENDPOINT, path, queryParams);
  }

  Future<ApiResponse> getRequest(Uri uri) {
    return http
        .get(
          uri,
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => http.Response(
            '{"message": "Timeout of 10 seconds}',
            504,
            request: http.Request('GET', uri),
          ),
        );
  }

  Future<ApiResponseWrapper<List<EnergyPoint>>> getEnergyInDay(
      String date, String type) async {
    final queryParams = {"date": date, "type": type};
    ApiRequestWrapper<List<EnergyPoint>> requestWrapper = ApiRequestWrapper(
        request: () => getRequest(getApiUri('/monitoring', queryParams)),
        decoder: (response) {
          var result =
              (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>)
                  .map((e) {
            if (DateTime.parse(e['timestamp']).isBefore(DateTime.now())) {
              return EnergyPoint.fromJson(e);
            }
          }).toList();
          return result.where((e) => e != null).cast<EnergyPoint>().toList();
        });
    return requestWrapper.execute();
  }

  void showSnackbarOnException(ApiResponseWrapper responseWrapper) {
    var showErrorMessage =
        errorMessageSnackBar(duration: const Duration(seconds: 7));

    if (responseWrapper.exception != null) {
      try {
        throw responseWrapper.exception!;
      } catch (e) {
        String message = e.toString();
        showErrorMessage(
          message,
        );
      }
    }
  }
}
