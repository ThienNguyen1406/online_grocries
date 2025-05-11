import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:online_grocries/view_model/splash_view_model.dart';
import 'package:path/path.dart' as pth;

typedef ResSuccess = Future<void> Function(Map<String, dynamic>);
typedef ResFailure = Future<void> Function(dynamic);

class ServiceCall {
  // POST request with JSON body
  static void post(Map<String, dynamic> parameter, String path,
      {bool isToken = false, ResSuccess? withSuccess, ResFailure? failure}) {
    Future(() {
      try {
        var headers = {'Content-Type': 'application/json'};  // Ensure Content-Type is JSON

        // If token is needed, add it to headers
        if (isToken) {
          var token = Get.find<SplashViewModel>().userPayload.value.authToken;
          headers["access_token"] = token ?? "";
        }

        // Encode parameters to JSON
        var body = json.encode(parameter);

        http.post(Uri.parse(path), body: body, headers: headers).then((value) {
          if (kDebugMode) {
            print(value.body);  // Log response body for debugging
          }

          try {
            var jsonObj = json.decode(value.body) as Map<String, dynamic>? ?? {};

            // If the request is successful, execute withSuccess callback
            if (withSuccess != null) withSuccess(jsonObj);
          } catch (err) {
            // Handle errors during decoding the response
            if (failure != null) failure(err.toString());
          }
        }).catchError((e) {
          // Handle errors during the HTTP request
          if (failure != null) failure(e.toString());
        });
      } catch (err) {
        // Handle any other errors
        if (failure != null) failure(err.toString());
      }
    });
  }

  // Multipart request for file upload
  static void multipart(Map<String, String> parameter, String path,
      {bool isToken = false, Map<String, File>? imgObj, ResSuccess? withSuccess, ResFailure? failure}) {
    Future(() {
      try {
        var uri = Uri.parse(path);
        var request = http.MultipartRequest('POST', uri);
        request.fields.addAll(parameter);

        // If token is needed, add it to headers
        if (isToken) {
          var token = Get.find<SplashViewModel>().userPayload.value.authToken;
          request.headers.addAll({"access_token": token ?? ""});
        }

        // Debugging logs
        if (kDebugMode) {
          print("ServiceCall: $path");
          print("ServiceCall para: ${parameter.toString()}");
          print("ServiceCall header: ${request.headers.toString()}");
        }

        // Add files to the request if any
        if (imgObj != null) {
          imgObj.forEach((key, value) {
            var multipartFile = http.MultipartFile(
                key, value.readAsBytes().asStream(), value.lengthSync(),
                filename: pth.basename(value.path));
            request.files.add(multipartFile);
          });
        }

        // Send the request
        request.send().then((response) async {
          var value = await response.stream.transform(utf8.decoder).join();

          if (kDebugMode) {
            print(value);  // Log response value for debugging
          }

          try {
            var jsonObj = json.decode(value) as Map<String, dynamic>? ?? {};

            // If the request is successful, execute withSuccess callback
            if (withSuccess != null) withSuccess(jsonObj);
          } catch (err) {
            // Handle errors during decoding the response
            if (failure != null) failure(err.toString());
          }
        }).catchError((e) {
          // Handle errors during the HTTP request
          if (failure != null) failure(e.toString());
        });
      } catch (err) {
        // Handle any other errors
        if (failure != null) failure(err.toString());
      }
    });
  }

  // Another version of multipart with different parameters (can be used for different file types)
  static void multipartNew(Map<String, String> parameter, String path,
      {bool isToken = false,
      Map<File, String>? imgObj,
      ResSuccess? withSuccess,
      ResFailure? failure}) {
    Future(() {
      try {
        var uri = Uri.parse(path);
        var request = http.MultipartRequest('POST', uri);
        request.fields.addAll(parameter);

        // If token is needed, add it to headers
        if (isToken) {
          var token = Get.find<SplashViewModel>().userPayload.value.authToken;
          request.headers.addAll({"access_token": token ?? ""});
        }

        // Debugging logs
        if (kDebugMode) {
          print("ServiceCall: $path");
          print("ServiceCall para: ${parameter.toString()}");
          print("ServiceCall header: ${request.headers.toString()}");
        }

        // Add files to the request if any
        if (imgObj != null) {
          imgObj.forEach((key, value) {
            var multipartFile = http.MultipartFile(
                value, key.readAsBytes().asStream(), key.lengthSync(),
                filename: pth.basename(key.path));
            request.files.add(multipartFile);
          });
        }

        // Send the request
        request.send().then((response) async {
          var value = await response.stream.transform(utf8.decoder).join();

          if (kDebugMode) {
            print(value);  // Log response value for debugging
          }

          try {
            var jsonObj = json.decode(value) as Map<String, dynamic>? ?? {};

            // If the request is successful, execute withSuccess callback
            if (withSuccess != null) withSuccess(jsonObj);
          } catch (err) {
            // Handle errors during decoding the response
            if (failure != null) failure(err.toString());
          }
        }).catchError((e) {
          // Handle errors during the HTTP request
          if (failure != null) failure(e.toString());
        });
      } catch (err) {
        // Handle any other errors
        if (failure != null) failure(err.toString());
      }
    });
  }
}
