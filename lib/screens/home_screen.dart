
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../config/app_config.dart';
import '../models/parking_ticket.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  String _formatarData(Timestamp time) {
    return DateFormat('dd/MM HH:mm').format(time.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.companyName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null, // Ação de check-in será adicionada depois
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Dashboard (Feature 2)
          StreamBuilder<int>(
            stream: _firestoreService.getActiveVehiclesCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data == 0) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Pátio vazio.'),
                  ),
                );
              }

              final activeCount = snapshot.data!;
              final availableSpots = AppConfig.totalParkingSpots - activeCount;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Carros no Pátio: $activeCount'),
                      Text('Vagas Disponíveis: $availableSpots'),
                    ],
                  ),
                ),
              );
            },
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Veículos Ativos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          // Lista de Veículos Ativos (Feature 3)
          Expanded(
            child: StreamBuilder<List<ParkingTicket>>(
              stream: _firestoreService.getActiveTickets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum veículo no pátio.'));
                }

                final tickets = snapshot.data!;

                return ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return ListTile(
                      title: Text(ticket.plate, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Tipo: ${ticket.vehicleType} | Entrada: ${_formatarData(ticket.checkInTime)}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
