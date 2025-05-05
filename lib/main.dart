import 'package:flutter/material.dart';
import 'package:frontend_app_task/router/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

