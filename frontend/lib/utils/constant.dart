import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

const primaryColor =  Color.fromRGBO(19,133,13,1);

final dio = Dio();
// final BaseUrl = "http://10.0.2.2:5203/api";
final BaseUrl = "http://172.190.178.221/api"; //docker local
// final BaseUrl = "http://localhost:5203/api";
final GoogleSignIn GoogleAuth =  GoogleSignIn();

class Storage{
    static final  _storageBox = GetStorage();

    static void WriteValue(String key,var data){
        _storageBox.write(key, data);
    }

    static void WriteMappedValue(String key, dynamic? value){
        _storageBox.write(key, jsonEncode(value));
    }

    static String? ReadValue(String key ){
        try{ return _storageBox.read(key); }
        catch(e){ rethrow;}
    }

    static dynamic ReadMappedVaule(String key){

        try{var result = jsonDecode(_storageBox.read(key));
            return result!=null?result:"";}
        catch (e) {rethrow;}
    }
}