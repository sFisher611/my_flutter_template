import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_alice/alice.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:my_flutter_template/app/services/navigation_service.dart';

class ApiProvider {
  final String auth = "users/auth";
  late final Dio _dio;

  ApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://mainUrl.com/",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );


    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final box = GetIt.I.get<Box>();
          final token = box.get("token");
          
          options.headers.addAll({
            'Accept': 'application/json',
            if (token != null && token.toString().isNotEmpty)
              'Authorization': 'Bearer $token',
          });
          return handler.next(options);
        },
      ),
    );

   
    if (kDebugMode) {
      try {
        final navKey = GetIt.I.get<NavigationService>().navigatorKey;
        final alice = Alice(showNotification: true, navigatorKey: navKey);
        _dio.interceptors.add(alice.getDioInterceptor());
      } catch (e) {
        debugPrint("Alice initialization failed: $e");
      }
    }
  }


  Future<Map<String, dynamic>> _safeRequest(Future<Response> request) async {
    try {
      final response = await request;
      return {"data": response.data, "error": false};
    } catch (error) {
      if (error is DioException) {
        return {"data": error.response?.data ?? _getDioErrorMessage(error), "error": true};
      }
      return {"data": "Kutilmagan xatolik yuz berdi", "error": true};
    }
  }


  Future<Map<String, dynamic>> onGet({required String api, Map<String, dynamic>? params}) =>
      _safeRequest(_dio.get(api, queryParameters: params));

  Future<Map<String, dynamic>> onPost({required String api, Map<String, dynamic>? param, dynamic body}) =>
      _safeRequest(_dio.post(api, data: body, queryParameters: param));

  Future<Map<String, dynamic>> onPut({required String api, Map<String, dynamic>? param, dynamic body}) =>
      _safeRequest(_dio.put(api, data: body, queryParameters: param));

  Future<Map<String, dynamic>> onDelete({required String api, Map<String, dynamic>? param, dynamic body}) =>
      _safeRequest(_dio.delete(api, data: body, queryParameters: param));

  Future<Map<String, dynamic>> onUpload({
    required String api,
    Map<String, dynamic>? body,
    String? filePath,
    String fileKey = "file",
    ValueNotifier<double>? progressNotifier,
  }) async {
    try {
      final formData = FormData.fromMap(body ?? {});
      if (filePath != null && filePath.isNotEmpty) {
        formData.files.add(
          MapEntry(fileKey, await MultipartFile.fromFile(filePath)),
        );
      }

      final response = await _dio.post(
        api,
        data: formData,
        onSendProgress: (sent, total) {
          if (progressNotifier != null && total > 0) {
            progressNotifier.value = sent / total;
          }
        },
      );
      return {"data": response.data, "error": false};
    } catch (error) {
      if (error is DioException) {
        return {"data": error.response?.data ?? _getDioErrorMessage(error), "error": true};
      }
      return {"data": "Fayl yuklashda xatolik", "error": true};
    }
  }


  Stream<String> sendMessageStream({
    required String api,
    Map<String, dynamic>? param,
    dynamic body,
    required VoidCallback onDone,
  }) async* {
    try {
      final response = await _dio.post(
        api,
        data: body,
        queryParameters: param,
        options: Options(responseType: ResponseType.stream),
      );

      final contentType = response.headers.value('content-type') ?? '';
      
      if (contentType.contains('text/event-stream')) {
        String buffer = ''; // JSON bo'laklarini yig'ish uchun buffer
        
        await for (final chunk in response.data.stream) {
          buffer += utf8.decoder.convert(chunk);
          final lines = buffer.split('\n');
          
          // Oxirgi qator to'liq bo'lmasligi mumkin, uni keyingi chunk uchun saqlaymiz
          buffer = lines.removeLast(); 

          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isEmpty) continue;
            
            if (trimmed.startsWith('data: ')) {
              final data = trimmed.substring(6).trim();
              if (data == '[done]' || data == '[DONE]') {
                onDone();
                return;
              }

              try {
                final parsed = jsonDecode(data);
                if (parsed['chunk'] != null) {
                  yield parsed['chunk'] as String;
                }
                if (parsed['done'] == true) {
                  onDone();
                }
              } catch (_) {
                // To'liq bo'lmagan JSON satrlarini o'tkazib yuboradi
              }
            }
          }
        }
      } else {
        final data = await response.data.stream.toBytes();
        final json = jsonDecode(utf8.decode(data));
        yield json['text'] ?? json['response'] ?? "";
        onDone();
      }
    } on DioException catch (e) {
      yield _getErrorMessage(e);
    }
  }

  // Dio Xatolik xiyoboni
  String _getDioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Server bilan ulanish vaqti tugadi";
      case DioExceptionType.receiveTimeout:
        return "Serverdan javob olish vaqti tugadi";
      case DioExceptionType.badResponse:
        return "Server noto'g'ri javob qaytardi: ${e.response?.statusCode}";
      default:
        return "Internet aloqasi mavjud emas yoki uzilib qoldi";
    }
  }

  String _getErrorMessage(DioException e) {
    if (e.response?.statusCode == 401) {
      return "I'm experiencing authentication issues. Please try again.";
    } else if (e.response?.statusCode == 429) {
      return "I'm receiving too many requests. Please try again in a moment.";
    }
    return "I'm having trouble connecting right now. Please try again.";
  }
}