import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/transfer/providers/transfer_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SendMoneyScreen extends StatefulWidget {
  final String? recipientName;
  final String? recipientPhone;

  const SendMoneyScreen({
    super.key,
    this.recipientName,
    this.recipientPhone,
  });

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _receiveAmountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;
  double _fee = 0.0;
  double _sendAmount = 0.0;
  String _selectedCountryCode = '+225';
  static const double FEE_PERCENTAGE = 0.009;

  @override
  void initState() {
    super.initState();
    if (widget.recipientPhone != null) {
      _phoneController.text = widget.recipientPhone!;
    }
    if (widget.recipientName != null) {
      _nameController.text = widget.recipientName!;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _receiveAmountController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateAmounts(String value) {
    final receiveAmount = double.tryParse(value) ?? 0;
    setState(() {
      _fee = receiveAmount * (FEE_PERCENTAGE / (1 - FEE_PERCENTAGE));
      _sendAmount = receiveAmount + _fee;
      if (_sendAmount > 0) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _setAmount(double amount) {
    _receiveAmountController.text = amount.toString();
    _updateAmounts(amount.toString());
  }

  Future<void> _showSuccessDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/success.json',
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                Text(
                  'Transfer Successful!',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have sent ${NumberFormat.currency(symbol: '', decimalDigits: 0).format(double.parse(_receiveAmountController.text))}F',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Return to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendMoney() async {
    if (!_formKey.currentState!.validate()) return;

    final receiveAmount = double.tryParse(_receiveAmountController.text);
    if (receiveAmount == null || receiveAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final transferProvider = context.read<TransferProvider>();
      await transferProvider.sendMoney(
        recipientPhone:
            '$_selectedCountryCode${_phoneController.text.replaceAll(' ', '')}',
        amount: _sendAmount,
      );

      if (!mounted) return;
      await _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.select((AuthProvider p) => p.balance);
    final currencyFormat = NumberFormat.currency(
      symbol: '',
      locale: 'fr_FR',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.recipientName != null) ...[
                Text(
                  'To',
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.recipientName!,
                  style: AppTypography.titleLarge,
                ),
                Text(
                  widget.recipientPhone!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
              ] else ...[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recipient name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CountryCodePicker(
                        onChanged: (country) {
                          setState(() {
                            _selectedCountryCode = country.dialCode!;
                          });
                        },
                        initialSelection: 'CI',
                        favorite: const ['CI', 'BF'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (value.length != 10) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              Text(
                'Receive Amount',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              TextFormField(
                controller: _receiveAmountController,
                keyboardType: TextInputType.number,
                onChanged: _updateAmounts,
                decoration: InputDecoration(
                  hintText: '0',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  suffixText: 'F',
                ),
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.textDark,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  if (amount < 5) {
                    return '5F is the minimum amount';
                  }
                  if (_sendAmount > balance) {
                    return 'Insufficient balance';
                  }
                  return null;
                },
              ),
              const Divider(),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Amount',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _sendAmount > 0
                          ? '${currencyFormat.format(_sendAmount)}F'
                          : '-',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "SwiftWallet's fee = 0.9%",
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${currencyFormat.format(_fee)}F)',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_receiveAmountController.text.isNotEmpty &&
                  _sendAmount > balance) ...[
                const SizedBox(height: 8),
                Text(
                  'Insufficient balance. Your balance is ${currencyFormat.format(balance)}F.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildQuickAmountButton(500),
                  const SizedBox(width: 8),
                  _buildQuickAmountButton(1000),
                  const SizedBox(width: 8),
                  _buildQuickAmountButton(2000),
                  const SizedBox(width: 8),
                  _buildQuickAmountButton(5000),
                  const SizedBox(width: 8),
                  _buildQuickAmountButton(10000),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendMoney,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAmountButton(double amount) {
    return Expanded(
      child: InkWell(
        onTap: () => _setAmount(amount),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryPurple),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            NumberFormat.currency(
              symbol: '',
              decimalDigits: 0,
            ).format(amount),
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primaryPurple,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
