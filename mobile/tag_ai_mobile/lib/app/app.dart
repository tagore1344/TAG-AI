// mobile/tag_ai_mobile/lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_ai_mobile/app/theme.dart';
import 'package:tag_ai_mobile/features/connection/connection_controller.dart' as tag_ai;
import 'package:tag_ai_mobile/features/pairing/pairing_screen.dart';
import 'package:tag_ai_mobile/features/home/home_screen.dart';
import 'package:tag_ai_mobile/features/chat/chat_screen.dart';
import 'package:tag_ai_mobile/features/control/control_screen.dart';
import 'package:tag_ai_mobile/features/proposals/proposals_screen.dart';
import 'package:tag_ai_mobile/features/voice/voice_screen.dart';

class TagAIApp extends StatelessWidget {
  const TagAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tag AI',
      theme: TagAITheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const MainGatekeeper(),
    );
  }
}

class MainGatekeeper extends StatelessWidget {
  const MainGatekeeper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<tag_ai.ConnectionController>(
      builder: (context, controller, child) {
        if (!controller.isPaired) {
          return const PairingScreen();
        }
        return const NavigationScaffold();
      },
    );
  }
}

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    VoiceScreen(),
    HomeScreen(),
    ChatScreen(),
    ProposalsScreen(),
    ControlScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TagAITheme.obsidianBackground,
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: TagAITheme.spaceSurface,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: TagAITheme.cyanAccent,
          unselectedItemColor: TagAITheme.cleanGrey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Consolas',
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Consolas',
            fontSize: 9,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.circle_outlined),
              activeIcon: Icon(Icons.circle, color: TagAITheme.cyanAccent),
              label: 'Tag AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, color: TagAITheme.cyanAccent),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble, color: TagAITheme.cyanAccent),
              label: 'CHAT',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_outlined),
              activeIcon: Icon(Icons.fact_check, color: TagAITheme.cyanAccent),
              label: 'REVIEW',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune_outlined),
              activeIcon: Icon(Icons.tune, color: TagAITheme.cyanAccent),
              label: 'CONTROL',
            ),
          ],
        ),
      ),
    );
  }
}
