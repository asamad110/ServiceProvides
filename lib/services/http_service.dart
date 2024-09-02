import 'package:dio/dio.dart';

class HTTPService {
  final Dio _dio = Dio();

  HTTPService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: "https://softcodix.pythonanywhere.com/api/",
      /* queryParameters: {
        "api_key": CRYPTO_RANK_API_KEY,
      },*/
    );
  }

  Future<dynamic> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      Response response = await _dio.delete(path);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> post(
      String path, Map<String, dynamic>? queryParameters) async {
    try {
      Response response = await _dio.post(path,
          data: queryParameters,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ));
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<ApiResponse> patch(
      String path, Map<String, dynamic>? queryParameters) async {
    Response? response;
    try {
      response = await _dio.patch(path,
          data: queryParameters,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ));

      return ApiResponse("Success", true, response.data);
    } catch (e) {
      print(e);
      return ApiResponse(response?.statusMessage ?? "Failed", false, null);
    }
  }
}

class ApiResponse<T> {
  final String message;
  final bool status;
  final T data;
  ApiResponse(this.message, this.status, this.data);
}
