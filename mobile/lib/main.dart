import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/injection/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/monitoring/presentation/bloc/monitoring_bloc.dart';
import 'features/alerts/presentation/bloc/alerts_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await initializeDependencies();
  
  // Request permissions
  await _requestPermissions();
  
  runApp(const SitEyeApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.camera,
    Permission.location,
    Permission.notification,
    Permission.storage,
  ].request();
}

class SitEyeApp extends StatelessWidget {
  const SitEyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<DashboardBloc>()),
        BlocProvider(create: (_) => getIt<MonitoringBloc>()),
        BlocProvider(create: (_) => getIt<AlertsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'SitEye Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

// Core injection setup
Future<void> initializeDependencies() async {
  // Initialize dependency injection
  // This would be implemented with get_it or similar
}

// Placeholder for dependency injection
class GetIt {
  T call<T extends Object>() => throw UnimplementedError();
}

final getIt = GetIt();
