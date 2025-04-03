import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tripto/features/authentication/screens/home/drawer/drawer_item_screen/trusted_contact_screen.dart';
import 'package:tripto/provider/safety_provider.dart';
import 'know_more.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SafetyController safetyController = Get.put(SafetyController());
    final String title = "New Trusted Contacts";
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Toolkit", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your safety comes first. Here are some measures and provisions to ensure your safety.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => KnowMoreScreen()));
                },
                child: const Text(
                  'Know More',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                _buildSafetyOption("Live Safety Checks", Icons.security, () {
                  _showEmergencyOptions(context);
                }, screenWidth),
                _buildSafetyOption("Share Live Location", Icons.location_on, () {
                  safetyController.shareLocationWhatsApp();
                }, screenWidth),
              ],
            ),
            const SizedBox(height: 25),
            const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildSettingCard(context, title, '📞', "New Trusted Contacts", "Share ride trip details with your loved ones in a single tap"),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyOption(String title, IconData icon, VoidCallback onTap, double screenWidth) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.4,
        constraints: const BoxConstraints(minWidth: 160),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.blueAccent),
                const SizedBox(height: 10),
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, String title, String emoji, String mainText, String subText) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        leading: Text(emoji, style: const TextStyle(fontSize: 30)),
        title: Text(mainText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subText, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
        onTap: () {
          _onCardTap(context, title);
        },
      ),
    );
  }

  void _showEmergencyOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Emergency Service"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEmergencyTile(context, "Police", Icons.local_police, "100"),
              _buildEmergencyTile(context, "Fire Brigade", Icons.fire_truck, "101"),
              _buildEmergencyTile(context, "Ambulance", Icons.medical_services, "102"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmergencyTile(BuildContext context, String title, IconData icon, String number) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      subtitle: Text(number),
      onTap: () async {
        Navigator.pop(context);
        if (await Permission.phone.request().isGranted) {
          final Uri phoneUri = Uri.parse('tel:$number');
          if (await canLaunchUrl(phoneUri)) {
            await launchUrl(phoneUri);
            Fluttertoast.showToast(msg: 'Calling $title...');
          } else {
            Fluttertoast.showToast(msg: 'Could not launch dialer');
          }
        }
      },
    );
  }

  void _onCardTap(BuildContext context, String title) {
    if (title == 'New Trusted Contacts') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrustedContactsScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clicked on $title')),
      );
    }
  }
}
