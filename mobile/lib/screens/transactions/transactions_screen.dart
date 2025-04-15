import 'package:flutter/material.dart';
import '../../widgets/app_logo.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const AppLogo(
                size: 48,
                text: "Track Every Transaction",
                color: Colors.white,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  final bool isSent = index.isEven;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        child: Icon(
                          isSent ? Icons.call_made : Icons.call_received,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        isSent ? 'Sent to John' : 'Received from Alice',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '2 hours ago',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Text(
                        isSent ? '- XOF 5,000' : '+ XOF 10,000',
                        style: TextStyle(
                          color: isSent ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
