import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tripto/features/rides/ride_provider.dart';

class RideHistoryScreen extends StatefulWidget {
  final String userId;

  const RideHistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _RideHistoryScreenState createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RideHistoryProvider>(context, listen: false)
            .getRideHistory(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(title: const Text("Ride History"),backgroundColor: Colors.white),
        body: Consumer<RideHistoryProvider>(
            builder: (context, provider, child) {
              if (provider.rideHistory.isEmpty) {
                return const Center(child: Text("No ride history available"));
              }
              return ListView.builder(
                itemCount: provider.rideHistory.length,
                itemBuilder: (context, index) {
                  final trip = provider.rideHistory[index];
                  String formattedDate = (trip['createdAt'] is String)
                      ? DateFormat('MMM d, yyyy - hh:mm a').format(
                    DateTime.parse(trip['createdAt']),
                  )
                      : "Unknown Date";
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.electric_rickshaw, color: Colors.blue),
                      title: Text("Trip Type: ${trip['type'] ?? 'Unknown'}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Driver ID: ${trip['driverID']}"),
                          Text("Pickup: ${trip['pickupAddress']}"),
                          Text("Drop: ${trip['dropAddress']}"),
                          Text("Date: $formattedDate"),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              );
            },
            ),
        );
    }
}
