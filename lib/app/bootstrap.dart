import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

/// Bootstraps the application, executing all necessary setups before running the app.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Any asynchronous operations (initializing databases, local storage, network caches) go here.

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
