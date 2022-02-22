String secondsToHMS(int seconds) {
  Duration tmp = Duration(seconds: seconds);
  return tmp.toString().substring(0, 7);
}