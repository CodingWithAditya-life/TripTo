import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler{
  static Future<bool> checkLocationPermission() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse || permission == LocationPermission.always;
  }

  static Future<bool> checkBackgroundLocationPermission() async{
    if(await Geolocator.isLocationServiceEnabled()){
      var status = await Permission.locationAlways.request();
      if(!status.isGranted){
        status = await Permission.locationAlways.request();
      }
      return status.isGranted;
    }
    return false;
  }

  static Future<bool> checkActivityRecognitionPermission() async{
    var status = await Permission.activityRecognition.status;
    if(status.isGranted){
      status = await Permission.activityRecognition.request();
    }
    return status.isGranted;
  }

  static Future<bool> requestAllPermission() async{
    bool location = await checkLocationPermission();
    bool backgroundLocation = await checkBackgroundLocationPermission();
    bool activityRecognition = await checkActivityRecognitionPermission();

    return location && backgroundLocation && activityRecognition;
  }
}
