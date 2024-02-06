
import 'dart:io';
import 'package:app_ft_movies/app/data/apis/services.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DependencyInjections implements Bindings {
  @override
  Future<void> dependencies() async {
       final dio = await Get.putAsync(() => _dio());
       Get.put(Services(dio));
       
  
  }

  Future<Dio> _dio() async {
    var dio = Dio();
    dio.interceptors.add(CurlLoggerDioInterceptor(
      printOnSuccess: true
    ));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));


      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          // var fileResponse = await DefaultCacheManager().getFileFromCache(options.uri.toString());
          // if (fileResponse != null && fileResponse.file.existsSync()) {
          //   handler.resolve(Response(
          //     requestOptions: options,
          //     statusCode: 200,
          //     data: await fileResponse.file.readAsBytes(),

          //   ));
          // } else {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            // String token =  prefs.getString(GlobalData.token)!=null? prefs.getString(GlobalData.token)??"":GlobalData.storeToken;
            options.headers = {
              "Access-Control-Allow-Origin": "*",
              "Authorization": "Bearer ",

              ...options.headers,
            };
            handler.next(options);
          },

        // },
          onError: ( error, handler) async{
          if(error.response?.statusCode == HttpStatus.unauthorized){
           
          }
          else{
            handler.next(error);
          }


          },
        onResponse: (response,handler)async{
          
          if (response.statusCode == 200 && response.data is List<int>) {
            
          }
          handler.next(response);
        }
      ));
      return dio;

    }



  
}