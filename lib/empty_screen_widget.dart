import 'package:flutter/material.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset('images/empty_screen.png'),
          const SizedBox(height: 30),
          Text(
            lang.S.of(context).noData,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
