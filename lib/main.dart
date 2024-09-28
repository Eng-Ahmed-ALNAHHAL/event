import 'package:cinema/backend/authentication.dart';
import 'package:cinema/backend/dio.dart';
import 'package:cinema/backend/shared_pref.dart';
import 'package:cinema/state_management/cubit.dart';
import 'package:cinema/state_management/states.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'firebase_options.dart';

/// Main function to initialize the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Dio with the provided API key
  await DioHelper.init("71c06a31c4e55927bf09eadeaabd8d0171851701");

  // Initialize shared preferences
  await SharedPref.init();
 // WindowManager.instance.setMinimumSize(const Size(950, 800));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CubitClass()
        ..getGuests()
        ..getReservations()
        ..getMovies(),
      child: BlocBuilder<CubitClass, AppState>(
        builder: (context, state) {
          CubitClass cub = CubitClass.get(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: cub.toggleLightAndDark(context),
            home: const Auth(),
          );
        },
      ),
    );
  }
}
