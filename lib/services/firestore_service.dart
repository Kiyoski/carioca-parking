
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/parking_ticket.dart';

class FirestoreService {
  final CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');

  Future<ParkingTicket> checkInVehicle(String plate, String vehicleType) async {
    // Cria um novo ticket
    ParkingTicket newTicket = ParkingTicket(
      id: '', // O Firestore gerará o ID
      plate: plate.toUpperCase(),
      vehicleType: vehicleType,
      checkInTime: Timestamp.now(),
      status: 'active',
      // O resto (checkOutTime, totalPrice, etc.) fica nulo
    );

    // Adiciona ao Firestore
    DocumentReference docRef = await _ticketsCollection.add(newTicket.toMap());

    // Atualiza o objeto com o ID real e retorna
    newTicket.id = docRef.id;
    return newTicket;
  }

  Stream<List<ParkingTicket>> getActiveTickets() {
    return _ticketsCollection
        .where('status', isEqualTo: 'active')
        .orderBy('checkInTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ParkingTicket.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<int> getActiveVehiclesCount() {
    return getActiveTickets().map((ticketsList) => ticketsList.length);
  }

  Future<void> checkOutVehicle(
      String ticketId, double totalPrice, String paymentMethod) async {
    await _ticketsCollection.doc(ticketId).update({
      'status': 'finished',
      'checkOutTime': Timestamp.now(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
    });
  }
}
