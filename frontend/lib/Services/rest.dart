
import 'package:frontend/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:frontend/Services/auth/google_auth.dart';

import '../pages/login.dart';

Future<void> HandleUnauthorization()async{
    var token = Storage.ReadMappedVaule("token");
    if(token["isExternal"]==true){
        getAuthorization(withPrevious: true);
    }
    else {Get.to(Material(child : loginPage()));}

}


Future<dynamic?> makeGetRequest(String Path) async {
   try{
        var AccessToken ="";
        try{
            var _AccessToken = Storage.ReadMappedVaule("token");
            AccessToken = _AccessToken!=null ? _AccessToken["token"] : "";
        }catch(e){AccessToken = "";}

       var response =  await dio.get(
                    "$BaseUrl$Path",
                    options: Options(
                        headers:{"Authorization":"Bearer $AccessToken"}
                    ));

        if(response.statusCode == 200) {
            return response;
        }

   }
   on DioException catch (e){

        if(e.response?.statusCode==401){
            await HandleUnauthorization();
            print(e.requestOptions.headers);
        }
        return null;
   }

}

Future<dynamic?> makePostRequest(String Path,Map data) async {

   try{
        var AccessToken ="";
        try{
            var _AccessToken = Storage.ReadMappedVaule("token");
            AccessToken = _AccessToken!=null ? _AccessToken["token"] : "";
        }catch(e){AccessToken = "";}

        print("$BaseUrl$Path");
        var response =  await dio.post(
                            "$BaseUrl$Path",
                            data: data,
                            options: Options(
                                headers:{"Authorization":"Bearer $AccessToken",}
                            )).timeout(Duration(seconds:10));


        if(response.statusCode == 200) {
            return response;
        }

   }on DioException catch (e){
        print(e.message);
        if(e.response?.statusCode==401)
            await HandleUnauthorization();
        return null;
   }
}

Future<dynamic?> makePutRequest(String Path,Map data) async {

   try{
        var AccessToken ="";
        try{
            var _AccessToken = Storage.ReadMappedVaule("token");
            AccessToken = _AccessToken!=null ? _AccessToken["token"] : "";
        }catch(e){AccessToken = "";}

        print("$BaseUrl$Path");
        var response =  await dio.put(
                            "$BaseUrl$Path",
                            data: data,
                            options: Options(
                                headers:{"Authorization":"Bearer $AccessToken",}
                            )).timeout(Duration(seconds:10));


        if(response.statusCode == 200) {
            return response;
        }

   }on DioException catch (e){
        print(e.message);
        if(e.response?.statusCode==401)
            await HandleUnauthorization();
        return null;
   }
}



