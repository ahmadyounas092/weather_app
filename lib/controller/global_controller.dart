
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/fetch_weather.dart';
import '../model/weather_data.dart';

class GlobalController extends GetxController {
  //create various variables
  final RxBool _isLoading = true.obs;
  final RxDouble _lattitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  // instance for them to be called
  RxBool checkLoading() => _isLoading;

  RxDouble getLattitude() => _lattitude;

  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;

  requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    } else {
      getIndex();
    }
    super.onInit();
  }

  void getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    //return isServiceNotEnabled
    if (!isServiceEnabled) {
      // Show dialog asking user to turn on location
      return;
    }
    //check current status of permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      // Handle permission denied forever
      return;
    } else if (locationPermission == LocationPermission.denied) {
      //request permission again
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        // Handle permission denied
        return;
      }
    }
    // getting the current position of the user
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .timeout(const Duration(seconds: 10)) // Add timeout
        .then((value) {
      // update our latiitude and longitude
      _lattitude.value = value.latitude;
      _longitude.value = value.longitude;
      //calling our weather api

      return fetchWeatherAPI()
          .processData(value.latitude, value.longitude)
          .then((value) {
        weatherData.value = value;
        _isLoading.value = false;
      });
    }).catchError((error) {
      // Handle timeout error
    });
  }

  RxInt getIndex() {
    return _currentIndex;
  }
}
