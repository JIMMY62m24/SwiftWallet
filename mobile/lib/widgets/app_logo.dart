import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final String? text;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 64,
    this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.account_balance_wallet,
          size: size,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        if (text != null) ...[
          const SizedBox(height: 16),
          Text(
            text!,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color ?? Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ],
    );
  }
}
