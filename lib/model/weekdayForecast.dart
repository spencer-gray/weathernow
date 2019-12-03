// stores weekday forecast to be used for charts
class WeekdayForecast {
  String weekday;
  double dailyLow;
  double dailyHigh;

  WeekdayForecast({this.weekday, this.dailyLow, this.dailyHigh});

  String toString() {
    return 'WeekdayForecast($weekday, $dailyLow, $dailyHigh)';
  }
}