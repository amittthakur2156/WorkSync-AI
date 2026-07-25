import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() {
  // Ensure Flutter is ready before any logic
  WidgetsFlutterBinding.ensureInitialized();

  // Run the bootstrapper instantly to unblock the native splash screen
  runApp(const WorkSyncBootstrapper());
}

/// A minimal widget that handles critical service initialization 
/// without blocking the first frame of the app.
class WorkSyncBootstrapper extends StatefulWidget {
  const WorkSyncBootstrapper({super.key});

  @override
  State<WorkSyncBootstrapper> createState() => _WorkSyncBootstrapperState();
}

class _WorkSyncBootstrapperState extends State<WorkSyncBootstrapper> {
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Configure Firestore
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. If services are ready, launch the full app with Riverpod
    if (_isInitialized) {
      return const ProviderScope(
        child: WorkSyncApp(),
      );
    }

    // 2. If there's a critical error, show it simply
    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: Text("Startup Error: $_error")),
        ),
      );
    }

    // 3. While initializing, show a minimal "App Loading" screen
    // This replaces the native Android/iOS splash logo immediately.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show your logo if possible, or just a spinner
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Initializing WorkSync...",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkSyncApp extends ConsumerWidget {
  const WorkSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'WorkSync AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
