// mobile/tag_ai_mobile/lib/features/pairing/pairing_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_ai_mobile/app/theme.dart';
import 'package:tag_ai_mobile/features/connection/connection_controller.dart' as tag_ai;

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final _hostController = TextEditingController(text: '192.168.1.10:8000');
  final _codeController = TextEditingController();
  final _nameController = TextEditingController(text: "Tag AI's Phone");

  @override
  void dispose() {
    _hostController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onPairPressed(BuildContext context) async {
    final host = _hostController.text.trim();
    final code = _codeController.text.trim();
    final name = _nameController.text.trim();

    if (host.isEmpty || code.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the host, pairing PIN, and device name.')),
      );
      return;
    }

    try {
      await context.read<tag_ai.ConnectionController>().pairDevice(host, code, name);
    } catch (_) {}
  }

  static const _labelStyle = TextStyle(
    fontFamily: 'Consolas',
    fontSize: 11,
    color: TagAITheme.cleanGrey,
    letterSpacing: 1.1,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TagAITheme.obsidianBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Consumer<tag_ai.ConnectionController>(
            builder: (context, controller, _) {
              final isPairing = controller.state == tag_ai.ConnectionState.pairing;
              final hasError = controller.state == tag_ai.ConnectionState.error;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 44),
                  const Center(
                    child: Text(
                      'Tag AI',
                      style: TextStyle(
                        fontFamily: 'Consolas',
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: TagAITheme.cyanAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'PAIR YOUR PERSONAL AI',
                      style: TextStyle(
                        fontFamily: 'Consolas',
                        fontSize: 10,
                        color: TagAITheme.cleanGrey,
                        letterSpacing: 2.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text('Tag AI GATEWAY HOST', style: _labelStyle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _hostController,
                    style: const TextStyle(fontFamily: 'Consolas'),
                    decoration: const InputDecoration(hintText: '192.168.1.10:8000'),
                  ),
                  const SizedBox(height: 18),
                  const Text('PHONE NAME', style: _labelStyle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(fontFamily: 'Inter'),
                    decoration: const InputDecoration(hintText: "Tag AI's Phone"),
                  ),
                  const SizedBox(height: 18),
                  const Text('6-DIGIT PAIRING PIN', style: _labelStyle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: const TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 20,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(hintText: 'XXXXXX', counterText: ''),
                  ),
                  const SizedBox(height: 30),
                  if (hasError)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: TagAITheme.rubyRed.withOpacity(0.08),
                        border: Border.all(color: TagAITheme.rubyRed.withOpacity(0.55)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        controller.errorMessage,
                        style: const TextStyle(color: TagAITheme.rubyRed, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (isPairing)
                    const Center(
                      child: CircularProgressIndicator(color: TagAITheme.cyanAccent),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => _onPairPressed(context),
                      child: const Text('PAIR AND CONNECT'),
                    ),
                  const SizedBox(height: 18),
                  const Text(
                    'The phone uses the paired Tag AI gateway for AI reasoning, tools, and memory.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TagAITheme.cleanGrey, fontSize: 11, height: 1.45),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
