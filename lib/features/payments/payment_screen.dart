import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:tripto/utils/constants/color.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(
          title: Text("Payment History", style: TextStyle(color: Colors.white)),
          backgroundColor: TripToColor.buttonColors,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('payment')
                .where('userId', isEqualTo: userId)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No Payment History Found"));
              }

              List<QueryDocumentSnapshot> payments = snapshot.data!.docs;

              return ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  var payment = payments[index].data() as Map<String, dynamic>;
                  var dateTime = (payment['createdAt'] as Timestamp).toDate();
                  var formattedDate = DateFormat('dd MMM • hh:mm a').format(dateTime);

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment['dropLocation'] ?? "Unknown Location",
                                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "₹${payment['amount']}",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.person, size: 16, color: Colors.grey[700]),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      "User: ${payment['userName']}",
                                      style: TextStyle(fontSize: 13.5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.local_taxi, size: 16, color: Colors.grey[700]),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      "Driver: ${payment['driverName']}",
                                      style: TextStyle(fontSize: 13.5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: payment['status'] == "Success" ? Colors.green[100] : Colors.red[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      payment['status'] == "Success" ? Icons.check_circle : Icons.cancel,
                                      color: payment['status'] == "Success" ? Colors.green : Colors.red,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Status: ${payment['status']}",
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: payment['status'] == "Success" ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  );
                },
              );
            },
            ),
        );
    }
}
