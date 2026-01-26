import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/model_viewer/presentation/bloc/model_viewer_bloc.dart';
import 'features/model_viewer/presentation/bloc/model_viewer_event.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Preload model at startup (using the new architecture)
  di.getIt<ModelViewerBloc>().add(
    const ModelViewerEvent.loadModel('lib/assets/3d-objects/gaming_chair.glb'),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avora - 3D Furniture Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: const Locale('ru'), // Russian as default
      supportedLocales: const [
        Locale('ru'), // Russian
        Locale('uz'), // Uzbek
        Locale('en'), // English
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: BlocProvider(
        create: (context) =>
            di.getIt<AuthBloc>()..add(const AuthEvent.checkAuthStatus()),
        child: const OnboardingScreen(),
      ),
    );
  }
}

/// Simple BlocObserver for logging (optional)
class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('${bloc.runtimeType} $error');
  }
}
