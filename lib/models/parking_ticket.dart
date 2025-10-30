
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingTicket {
  String id;
  final String plate;
  final String vehicleType;
  final Timestamp checkInTime;
  Timestamp? checkOutTime;
  double? totalPrice;
  String status;
  String? paymentMethod; // Novo campo

  ParkingTicket({
    required this.id,
    required this.plate,
    required this.vehicleType,
    required this.checkInTime,
    this.checkOutTime,
    this.totalPrice,
    required this.status,
    this.paymentMethod, // Adicionado ao construtor
  });

  Map<String, dynamic> toMap() {
    return {
      'plate': plate,
      'vehicleType': vehicleType,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod, // Adicionado ao mapa
    };
  }

  factory ParkingTicket.fromMap(Map<String, dynamic> map, String id) {
    return ParkingTicket(
      id: id,
      plate: map['plate'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      checkInTime: map['checkInTime'] as Timestamp,
      checkOutTime: map['checkOutTime'] as Timestamp?,
      totalPrice: (map['totalPrice'] as num?)?.toDouble(),
      status: map['status'] ?? 'active',
      paymentMethod: map['paymentMethod'] as String?,
    );
  }
}
