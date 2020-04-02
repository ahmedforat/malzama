import 'package:connectivity/connectivity.dart';


class NetWorkInfo{
  // when the returned value is false then there is no connection and vice versa
  static Future<bool> checkConnection()async{
    Connectivity connectivity = new Connectivity();
    ConnectivityResult connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}