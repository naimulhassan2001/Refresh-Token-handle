

import 'package:get/get.dart';
import 'package:untitled1/services/api_service.dart';

class RefreshTokenController extends GetxController {


  static aa() async {
    var response =await ApiService.getApi("https://api.dialogi.net/api/favourites") ;

    print("===============================>response ${response.responseJson}") ;

    print(response.runtimeType);
    print(response.statusCode);

  }
}