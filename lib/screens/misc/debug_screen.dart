import 'package:flutter/material.dart';

import '../../widgets/loading.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingSpinner();
  }
}
