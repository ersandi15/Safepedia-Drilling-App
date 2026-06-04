import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  // Mengambil 1 data (event) terbaru dari Accelerometer, lalu otomatis berhenti
  Future<AccelerometerEvent> getAccelerometerData() async {
    return await accelerometerEventStream().first;
  }

  // Mengambil 1 data (event) terbaru dari Gyroscope, lalu otomatis berhenti
  Future<GyroscopeEvent> getGyroscopeData() async {
    return await gyroscopeEventStream().first;
  }
}
