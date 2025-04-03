import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RideScreen extends StatefulWidget {
  final String tripId;

  RideScreen({required this.tripId});

  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  DatabaseReference? tripRef;
  Map<dynamic, dynamic>? tripData;
  bool isDriverAssigned = false;

  @override
  void initState() {
    super.initState();
    tripRef = FirebaseDatabase.instance.ref('tripTracker/${widget.tripId}');

    tripRef!.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          tripData = event.snapshot.value as Map<dynamic, dynamic>;
          isDriverAssigned = tripData!['driverName'] != null;
        });
      }
    });
  }

  void showDriverDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Full screen bottom sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: isDriverAssigned ? 300 : 200,
          child: tripData == null || !isDriverAssigned
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Waiting for driver to accept...', style: TextStyle(fontSize: 16)),
              ],
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('Driver Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Divider(),
              SizedBox(height: 10),
              Text('🚗 Driver: ${tripData!['driverName']}',
                  style: TextStyle(fontSize: 18)),
              Text('📞 Phone: ${tripData!['driverPhone'] ?? 'Not available'}',
                  style: TextStyle(fontSize: 16)),
              Text('📍 Pickup: ${tripData!['pickUpAddress']}',
                  style: TextStyle(fontSize: 16)),
              Text('📍 Drop: ${tripData!['dropAddress']}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ride Tracking')),
      body: Center(
        child: ElevatedButton(
          onPressed: showDriverDetails,
          child: Text("Show Driver Details"),
        ),
      ),
    );
  }
}
