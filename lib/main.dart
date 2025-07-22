
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/cubit/prod_orders_cubit.dart';
import 'constants/strings.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/theme/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MyApp(
      initialRoute: AppRoutes.splash,
      routes: AppRoutes(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRoutes routes;
  final String initialRoute;
  const MyApp({super.key, required this.routes, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       
      ],
      child: BlocBuilder<LanguageCubit, String>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) {
              return MaterialApp(
                locale: Locale(languageState),
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                title: appName,
                initialRoute: initialRoute,
                onGenerateRoute: routes.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
