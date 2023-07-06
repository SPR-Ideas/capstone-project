import "../rest.dart";
import 'package:google_sign_in/google_sign_in.dart';


import "../../utils/constant.dart";



Future<GoogleSignInAccount?> getAccount({bool withPrevious=false}) async {
    var account = (withPrevious)? await GoogleAuth.signInSilently():await GoogleAuth.signIn();
    print(account!.photoUrl);
    return account ;
}

void googleSignOut(){
    GoogleAuth.signOut();
}

Future<dynamic> makeSignUp() async{
    try {
        var account = await getAccount();
        if(account!=null){
            var bodyParams = {
            "username": account.email,
            "name": account.displayName,
            "isExternal": true,
            "displayImage": account.photoUrl,
            };
        var response   = await dio.post("$BaseUrl/Auth/SignUp",data:bodyParams);

        }
    }
    catch (e) { print(e);}
}

Future<dynamic?> getAuthorization({bool withPrevious=false}) async {
try{
    var account = withPrevious ? await getAccount(withPrevious: true):await getAccount();
    if (account==null){return null; }

    var response = makePostRequest("/Auth/Signin",
    {
        "Username" : account.email,
        "isExternal" : true
    });

    return response;
}
catch(e){print(e);}
}
