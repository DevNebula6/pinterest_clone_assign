import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/create_option_sheet.dart';

class CreatePinView extends ConsumerStatefulWidget {
  const CreatePinView({super.key});

  @override
  ConsumerState<CreatePinView> createState() => _CreatePinViewState();
}

class _CreatePinViewState extends ConsumerState<CreatePinView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOptions();
    });
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateOptionSheet(onDismiss: () => Navigator.pop(context)),
    ).whenComplete(() {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.shrink(),
    );
  }
}
