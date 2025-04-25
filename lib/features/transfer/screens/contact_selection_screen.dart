import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import 'send_money_screen.dart';

class Contact {
  final String name;
  final String phoneNumber;
  final String? avatarUrl;
  final bool isFavorite;
  final DateTime? lastTransaction;
  final List<String> categories;
  final double? lastTransactionAmount;
  final String? countryCode;
  final String? countryFlag;

  Contact({
    required this.name,
    required this.phoneNumber,
    this.avatarUrl,
    this.isFavorite = false,
    this.lastTransaction,
    this.categories = const [],
    this.lastTransactionAmount,
    this.countryCode,
    this.countryFlag,
  });
}

class ContactSelectionScreen extends StatefulWidget {
  const ContactSelectionScreen({super.key});

  @override
  State<ContactSelectionScreen> createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Temporary mock data - This should come from a contacts provider
  final List<Contact> _contacts = [
    Contact(
      name: 'PDG DIOP ALPHA',
      phoneNumber: '07 07 79 40 48',
      isFavorite: true,
      lastTransaction: DateTime.now().subtract(const Duration(days: 2)),
      categories: ['Family'],
      lastTransactionAmount: 500,
      countryCode: '+225',
    ),
    Contact(
      name: 'Diallo Kiosque',
      phoneNumber: '01 71 54 20 09',
      isFavorite: true,
      lastTransaction: DateTime.now().subtract(const Duration(days: 5)),
      categories: ['Business'],
      lastTransactionAmount: 1000,
      countryCode: '+225',
    ),
    Contact(
      name: 'Manu Le Coq Martial',
      phoneNumber: '01 50 68 88 93',
      isFavorite: true,
      categories: ['Business'],
      lastTransactionAmount: 2000,
      countryCode: '+225',
    ),
    Contact(
      name: 'ALBERT COMPAORE',
      phoneNumber: '+226 72 53 22 35',
      categories: ['Business'],
      countryCode: '+226',
      countryFlag: 'assets/flags/bf.png',
    ),
    // Add more contacts...
  ];

  List<Contact> get filteredContacts {
    return _contacts.where((contact) {
      final matchesSearch =
          contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              contact.phoneNumber
                  .replaceAll(' ', '')
                  .contains(_searchQuery.replaceAll(' ', ''));

      final matchesCategory = _selectedCategory == 'All' ||
          contact.categories.contains(_selectedCategory);

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Contact> get favoriteContacts {
    return filteredContacts.where((contact) => contact.isFavorite).toList();
  }

  List<Contact> get recentContacts {
    return filteredContacts
        .where((contact) => contact.lastTransaction != null)
        .toList()
      ..sort((a, b) => b.lastTransaction!.compareTo(a.lastTransaction!));
  }

  List<Contact> get otherContacts {
    return filteredContacts
        .where(
            (contact) => !contact.isFavorite && contact.lastTransaction == null)
        .toList();
  }

  Widget _buildContactAvatar(Contact contact) {
    if (contact.avatarUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(contact.avatarUrl!),
        backgroundColor: Colors.grey[200],
      );
    }

    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: Text(
        contact.name.substring(0, 1).toUpperCase(),
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.primaryPurple,
        ),
      ),
    );
  }

  String _formatLastTransaction(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildContactItem(Contact contact) {
    return ListTile(
      leading: Stack(
        children: [
          _buildContactAvatar(contact),
          if (contact.isFavorite)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star,
                  size: 12,
                  color: Colors.amber[600],
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              contact.name,
              style: AppTypography.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (contact.categories.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                contact.categories.first,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${contact.countryCode} ',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                contact.phoneNumber,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (contact.lastTransaction != null) ...[
            const SizedBox(height: 2),
            Text(
              'Last transaction: ${_formatLastTransaction(contact.lastTransaction!)}',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
      trailing: contact.lastTransactionAmount != null
          ? Text(
              '${contact.lastTransactionAmount!.toStringAsFixed(0)}F',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SendMoneyScreen(
              recipientName: contact.name,
              recipientPhone: contact.phoneNumber.replaceAll(' ', ''),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      selected: isSelected,
      label: Text(category),
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : 'All';
        });
      },
      backgroundColor: isSelected ? AppColors.primaryPurple : Colors.grey[200],
      labelStyle: AppTypography.labelMedium.copyWith(
        color: isSelected ? Colors.white : Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search by name or number',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      _buildCategoryChip('All'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Recent'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Family'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Business'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Friends'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (favoriteContacts.isNotEmpty) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Favorites',
                      style: AppTypography.titleLarge,
                    ),
                  ),
                  ...favoriteContacts.map(_buildContactItem),
                ],
                if (recentContacts.isNotEmpty) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Recent',
                      style: AppTypography.titleLarge,
                    ),
                  ),
                  ...recentContacts.map(_buildContactItem),
                ],
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'All Contacts',
                    style: AppTypography.titleLarge,
                  ),
                ),
                ...otherContacts.map(_buildContactItem),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SendMoneyScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primaryPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
