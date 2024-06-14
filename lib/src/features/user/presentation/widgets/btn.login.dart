import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonAccess extends StatelessWidget {
  const ButtonAccess({super.key});

  static const String text = 'Ingresar a Petmeals';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 46,
      child: TextButton(
        onPressed: () async {
          context.go('/home');
        },
        style: TextButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: const Color(0xFFffffff),
          foregroundColor: const Color(0xFF1f1f1f),
          disabledBackgroundColor: const Color(0xFF1f1f1f).withOpacity(0.45),
          disabledForegroundColor: const Color(0xFF1f1f1f).withOpacity(0.38),
          side: const BorderSide(color: Color(0xFF747775)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(text),
      ),
    );
  }
}
