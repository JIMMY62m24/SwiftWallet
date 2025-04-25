import 'package:flutter/material.dart';
import '../../models/contact.dart';
import '../../theme/app_theme.dart';
import '../../services/transfer_service.dart';

class SendAmountScreen extends StatefulWidget {
  final Contact recipient;

  const SendAmountScreen({
    super.key,
    required this.recipient,
  });

  @override
  State<SendAmountScreen> createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends State<SendAmountScreen> {
  static const double feePercentage = 0.01; // 1%
  String _amount = '';
  String _error = '';
  final TransferService _transferService = TransferService();
  bool _isLoading = false;

  void _addDigit(String digit) {
    setState(() {
      if (_amount.length < 10) {
        _amount += digit;
        _validateAmount();
      }
    });
  }

  void _removeDigit() {
    setState(() {
      if (_amount.isNotEmpty) {
        _amount = _amount.substring(0, _amount.length - 1);
        _validateAmount();
      }
    });
  }

  void _validateAmount() {
    setState(() {
      if (_amount.isEmpty) {
        _error = '';
        return;
      }

      double? amount = double.tryParse(_amount);
      if (amount == null) {
        _error = 'Invalid amount';
        return;
      }

      // Here you would check against the user's actual balance
      if (amount > 1000000) {
        // Example balance check
        _error = 'Insufficient balance. Your balance is 50F.';
      } else {
        _error = '';
      }
    });
  }

  double get _sendAmount => double.tryParse(_amount) ?? 0;

  double get _fee => _sendAmount * feePercentage;

  double get _receiveAmount => _sendAmount - _fee;

  Future<void> _sendMoney() async {
    if (_amount.isEmpty || _error.isNotEmpty) return;

    setState(() => _isLoading = true);

    try {
      final result = await _transferService.sendMoney(
        recipientPhoneNumber: widget.recipient.phoneNumber,
        amount: _sendAmount,
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          setState(() => _error = result['message']);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to send money. Please try again.';
        });
      }
    }
  }

  Widget _buildKeypadButton(String text, [VoidCallback? onTap]) {
    return Expanded(
      child: InkWell(
        onTap: onTap ?? () => _addDigit(text),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dividerGrey),
            color: AppTheme.white,
          ),
          child: text == 'backspace'
              ? const Icon(Icons.backspace_outlined)
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Send Money',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'To',
                    style: TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.recipient.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.recipient.phoneNumber,
                    style: TextStyle(
                      color: AppTheme.textGrey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send Amount',
                        style: TextStyle(
                          color:
                              _error.isEmpty ? AppTheme.textGrey : Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _amount.isEmpty ? '0' : _amount,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color:
                              _error.isEmpty ? AppTheme.textGrey : Colors.red,
                        ),
                      ),
                      if (_error.isNotEmpty)
                        Text(
                          _error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Receive Amount',
                        style: TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _receiveAmount.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 32,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Swift's fee = ${(feePercentage * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: AppTheme.primaryPurple,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isLoading || _error.isNotEmpty ? null : _sendMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Send',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ),
          Container(
            color: AppTheme.backgroundGrey,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildKeypadButton('1'),
                    _buildKeypadButton('2'),
                    _buildKeypadButton('3'),
                  ],
                ),
                Row(
                  children: [
                    _buildKeypadButton('4'),
                    _buildKeypadButton('5'),
                    _buildKeypadButton('6'),
                  ],
                ),
                Row(
                  children: [
                    _buildKeypadButton('7'),
                    _buildKeypadButton('8'),
                    _buildKeypadButton('9'),
                  ],
                ),
                Row(
                  children: [
                    const Spacer(),
                    _buildKeypadButton('0'),
                    _buildKeypadButton('backspace', _removeDigit),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
