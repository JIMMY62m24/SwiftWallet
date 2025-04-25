import 'package:flutter/material.dart';
import '../../models/contact.dart';
import '../../theme/app_theme.dart';
import 'send_amount_screen.dart';

class SelectRecipientScreen extends StatefulWidget {
  const SelectRecipientScreen({Key? key}) : super(key: key);

  @override
  State<SelectRecipientScreen> createState() => _SelectRecipientScreenState();
}

class _SelectRecipientScreenState extends State<SelectRecipientScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Contact> _favorites = [
    Contact(
        name: "PDG DIOP ALPHA 👊🏾👊🏾👊🏾💪", phoneNumber: "07 07 79 40 48"),
    Contact(name: "Diallo Kiosque", phoneNumber: "01 71 54 20 09"),
    Contact(
        name: "Manu Le Coq Martial (mobile)", phoneNumber: "01 50 68 88 93"),
    Contact(name: "Charle Hermann", phoneNumber: "07 88 20 58 97"),
    Contact(name: "Armelle Downstairs", phoneNumber: "07 77 41 23 46"),
  ];

  void _navigateToSendAmount(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendAmountScreen(recipient: contact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Send Money',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'To',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Enter phone number',
                    border: UnderlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _navigateToSendAmount(
                        Contact(
                          name: value,
                          phoneNumber: value,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
              child: const Icon(Icons.add, color: AppTheme.primaryPurple),
            ),
            title: const Text('Send to a new number'),
            onTap: () {
              // Focus the text field
              FocusScope.of(context).requestFocus(
                FocusNode(),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Favorites',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final contact = _favorites[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
                    child: const Icon(Icons.person_outline,
                        color: AppTheme.primaryPurple),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.phoneNumber),
                  onTap: () => _navigateToSendAmount(contact),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
