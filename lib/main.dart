import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'screens/login_page.dart';
import 'services/api_client.dart';
import 'services/auth_state.dart';
import 'screens/menu.dart';

void main() {
  final apiClient = ApiClient();

  runApp(MyApp(apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState(apiClient)),
      ],
      child: MaterialApp(
        title: 'MyPortfolio',
        debugShowCheckedModeBanner: false,

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        supportedLocales: const [Locale('en'), Locale('id')],

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF795548)),
          useMaterial3: true,
        ),

        home: MyHomePage(),
      ),
    );
  }
}
