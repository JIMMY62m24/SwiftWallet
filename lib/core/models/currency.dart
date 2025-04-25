import 'package:intl/intl.dart';

class Currency {
  final String code;
  final String symbol;
  final String name;
  final double rate; // Exchange rate from XOF
  final String locale;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.rate,
    required this.locale,
  });

  static const XOF = Currency(
    code: 'XOF',
    symbol: 'FCFA',
    name: 'West African CFA Franc',
    rate: 1.0,
    locale: 'fr_FR',
  );

  static const USD = Currency(
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
    rate: 0.0016, // 1 XOF = 0.0016 USD
    locale: 'en_US',
  );

  static const EUR = Currency(
    code: 'EUR',
    symbol: '€',
    name: 'Euro',
    rate: 0.0015, // 1 XOF = 0.0015 EUR
    locale: 'fr_FR',
  );

  static const GBP = Currency(
    code: 'GBP',
    symbol: '£',
    name: 'British Pound',
    rate: 0.0013, // 1 XOF = 0.0013 GBP
    locale: 'en_GB',
  );

  static const NGN = Currency(
    code: 'NGN',
    symbol: '₦',
    name: 'Nigerian Naira',
    rate: 0.7, // 1 XOF = 0.7 NGN
    locale: 'en_NG',
  );

  static const GHS = Currency(
    code: 'GHS',
    symbol: 'GH₵',
    name: 'Ghanaian Cedi',
    rate: 0.012, // 1 XOF = 0.012 GHS
    locale: 'en_GH',
  );

  static const all = [XOF, USD, EUR, GBP, NGN, GHS];

  String format(double amount) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      locale: locale,
      decimalDigits: code == 'XOF' ? 0 : 2,
    );
    return formatter.format(amount * rate);
  }

  double convertToXOF(double amount) {
    return amount / rate;
  }

  double convertFromXOF(double amount) {
    return amount * rate;
  }
}
