import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'db/db_init_web.dart' if (dart.library.io) 'db/db_init_ffi.dart' as db_initializer;
import 'screens/main_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // db_initializer.initializeDatabaseForDesktop();

  runApp(
    const ProviderScope(
      child: FlodoApp(),
    ),
  );
}

class FlodoApp extends StatelessWidget {
  const FlodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flodo Task Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightMasterpiece,
      home: const MainListScreen(),
    );
  }
}
