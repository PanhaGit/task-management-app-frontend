import 'package:flutter/material.dart';
import 'package:frontend_app_task/router/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MongKolApp());
}


class MongKolApp extends StatelessWidget {
  const MongKolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Mong Kol App Task",
      routerConfig: Routes.router,
    );
  }
}

