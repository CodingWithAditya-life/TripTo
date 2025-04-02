import 'package:flutter/material.dart';

class TrustedContactsScreen extends StatefulWidget {
  @override
  _TrustedContactsScreenState createState() => _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  List<String> trustedContacts = [];

  void _addContact() {
    setState(() {
      trustedContacts.add('New Contact ${trustedContacts.length + 1}');
    });
  }

  void _removeContact(int index) {
    setState(() {
      trustedContacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trusted Contacts')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _addContact,
            child: Text('Add Trusted Contact'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: trustedContacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(trustedContacts[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeContact(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
