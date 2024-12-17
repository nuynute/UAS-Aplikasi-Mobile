import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../models/favorite_wallpaper_model.dart';
import '../models/wallpaper.dart';
import '../services/database_service.dart';

// Fungsi untuk mengunduh gambar dan menyimpan ke folder Download
Future<void> downloadImage(String url) async {
  // Minta izin penyimpanan
  var status = await Permission.manageExternalStorage.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    status = await Permission.manageExternalStorage.request();
  }

  if (status.isGranted) {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Ambil nama file dari URL
        final imageName = path.basename(url);

        // Akses direktori Download
        final directory = Directory('/storage/emulated/0/Download');
        final localPath = path.join(directory.path, imageName);

        // Simpan file ke folder Download
        final imageFile = File(localPath);
        await imageFile.writeAsBytes(response.bodyBytes);

        print("Gambar berhasil diunduh: $localPath");
      } else {
        print("Gagal mengunduh gambar, status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saat mengunduh gambar: $e");
    }
  } else {
    print("Izin penyimpanan tidak diberikan.");
  }
}

class WallpaperDetailsScreen extends StatefulWidget {
  final Wallpaper wallpaper;

  const WallpaperDetailsScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperDetailsScreen> createState() => _WallpaperDetailsScreenState();
}

class _WallpaperDetailsScreenState extends State<WallpaperDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    final favoriteWallpapers = await DatabaseProvider.getAllFavoriteWallpapers();
    setState(() {
      isFavorite = favoriteWallpapers.any((favWallpaper) => favWallpaper.id == widget.wallpaper.id);
    });
  }

  Future<void> addToFavorites() async {
    final favoriteWallpaper = FavoriteWallpaper(
      id: widget.wallpaper.id,
      imageUrl: widget.wallpaper.imageUrl,
    );
    await DatabaseProvider.insertFavoriteWallpaper(favoriteWallpaper);
    setState(() => isFavorite = true);
  }

  Future<void> removeFromFavorites() async {
    await DatabaseProvider.deleteFavoriteWallpaper(widget.wallpaper.id);
    setState(() => isFavorite = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff01a081),
        title: const Text('Wallpaper Details'),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(widget.wallpaper.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => downloadImage(widget.wallpaper.imageUrl),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => isFavorite ? removeFromFavorites() : addToFavorites(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
