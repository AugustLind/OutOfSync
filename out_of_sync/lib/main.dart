import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:udp/udp.dart';
import 'package:image_picker/image_picker.dart';

part 'src/app_theme.dart';
part 'src/ios_widgets.dart';
part 'src/image_manager.dart';
part 'src/network_manager.dart';
part 'src/game.dart';
part 'src/game_page.dart';
part 'src/image_settings_page.dart';
part 'src/home_page.dart';
part 'src/lobby_page.dart';

Game? currentGame;
List<GameInfo> availableGames = [];

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Out of Sync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.backgroundColor,
          foregroundColor: AppTheme.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTheme.headlineTextStyle,
        ),
      ),
      home: const HomePage(),
    );
  }
}
