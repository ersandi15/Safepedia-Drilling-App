class DrillingActivityModel {
  int? id;
  String date;
  String holeId;
  double accelX;
  double accelY;
  double accelZ;
  double gyroX;
  double gyroY;
  double gyroZ;
  String imagePath;
  String status; // 'Complete' atau 'Not Complete'
  int isSubmitted; // 0 = Offline/Draft, 1 = Online/Submitted

  DrillingActivityModel({
    this.id,
    required this.date,
    required this.holeId,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.imagePath,
    required this.status,
    required this.isSubmitted,
  });

  // Konversi dari JSON/Map (Database) ke Object
  factory DrillingActivityModel.fromMap(Map<String, dynamic> map) {
    return DrillingActivityModel(
      id: map['id'],
      date: map['date'],
      holeId: map['holeId'],
      accelX: map['accelX'],
      accelY: map['accelY'],
      accelZ: map['accelZ'],
      gyroX: map['gyroX'],
      gyroY: map['gyroY'],
      gyroZ: map['gyroZ'],
      imagePath: map['imagePath'],
      status: map['status'],
      isSubmitted: map['isSubmitted'],
    );
  }

  // Konversi dari Object ke JSON/Map (untuk disimpan ke Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'holeId': holeId,
      'accelX': accelX,
      'accelY': accelY,
      'accelZ': accelZ,
      'gyroX': gyroX,
      'gyroY': gyroY,
      'gyroZ': gyroZ,
      'imagePath': imagePath,
      'status': status,
      'isSubmitted': isSubmitted,
    };
  }
}