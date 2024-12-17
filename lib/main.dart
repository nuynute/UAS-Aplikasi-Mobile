import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gallerify/providers/app_state.dart';
import 'package:gallerify/screens/bottom_bar.dart';
import 'package:gallerify/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.initDatabase();
  runApp(const WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WallpaperProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallpaper App',
        home: BottomBar(),
      ),
    );
  }
}
