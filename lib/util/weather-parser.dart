import 'package:weather/weather.dart';


// Finds the min weather in a list of Weathers
// (Not required if OpenWeather API is used...)
double dailyMinTemp(List<Weather> weathers) {
  double min;
  for (var i=0; i < weathers.length; i++) {
    if (i == 0) {
      min = weathers[i].tempMin.celsius;
    }
    if (weathers[i].tempMin.celsius < min) {
      min = weathers[i].tempMin.celsius;
    }
  }
  return min;
}