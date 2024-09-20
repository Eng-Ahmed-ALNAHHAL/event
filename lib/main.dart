import 'package:cinema/backend/authentication.dart';
import 'package:cinema/backend/dio.dart';
import 'package:cinema/backend/shared_pref.dart';
import 'package:cinema/state_management/cubit.dart';
import 'package:cinema/state_management/states.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DioHelper.init("71c06a31c4e55927bf09eadeaabd8d0171851701");
  await SharedPref.init();
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
              home: const  Auth(),
            );
          }),
    );
  }
}
