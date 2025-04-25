import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool _isScanning = true;
  final MobileScannerController _scannerController = MobileScannerController();

  void _onDetectBarcode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      // Handle the scanned QR code
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        title: Text(
          _isScanning ? 'Scan QR Code' : 'My QR Code',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isScanning ? Icons.qr_code : Icons.qr_code_scanner,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isScanning = !_isScanning;
              });
            },
          ),
        ],
      ),
      body: _isScanning ? _buildScanner() : _buildMyQRCode(),
    );
  }

  Widget _buildScanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: MobileScanner(
                controller: _scannerController,
                onDetect: _onDetectBarcode,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Scan a QR code to send money',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyQRCode() {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null) {
      return const Center(
        child: Text('Error: User ID not available'),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: QrImageView(
              data: userId.toString(),
              version: QrVersions.auto,
              size: 250,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your QR Code',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Share this code to receive money',
            style: TextStyle(
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }
}
