import 'package:cinema/ui/login.dart';
import 'package:cinema/ui/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state_management/cubit.dart';
import '../state_management/states.dart';





class Auth extends StatelessWidget {
  const Auth ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitClass, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData ) {
              return const MainPage();
            }
            return Login();

          },
        );
      },
    );
  }
}