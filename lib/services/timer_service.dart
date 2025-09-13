import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService extends ChangeNotifier {
  static final TimerService _instance = TimerService._internal();
  
  factory TimerService() => _instance;
  
  TimerService._internal();
  
  Timer? _timer;
  int _currentSecond = 0;
  
  int get currentSecond => _currentSecond;
  
  void startTimer() {
    if (_timer != null && _timer!.isActive) return;
    
    _currentSecond = DateTime.now().second;
    notifyListeners();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentSecond = DateTime.now().second;
      notifyListeners();
    });
  }
  
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
  
  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}