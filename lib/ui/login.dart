import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cinema/backend/shared_pref.dart';
import 'package:cinema/ui/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

import '../components/constants.dart';
import '../state_management/cubit.dart';
import '../state_management/states.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor3,
          body: Form(
            key: formKey,
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    AppTexts.assetsImage('just4prog.png')   ,
                    width: AppDimensions.d270,
                    height: AppDimensions.d145,
                  ),
                ),
                const SizedBox(height: AppDimensions.d30),
                _buildLoginTitle(),
                const SizedBox(height: AppDimensions.d70),
                _buildTextField(
                  controller: emailController,
                  icon: Icons.person,
                  label: AppTexts.email,
                ),
                const SizedBox(height: AppDimensions.d20),
                _buildTextField(
                  controller: passController,
                  icon: Icons.key,
                  label: AppTexts.password,
                ),
                const SizedBox(height: AppDimensions.d70),
                _buildLoginButton(cub),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _buildLoginTitle() {
    return Center(
      child: Stack(
        children: [
          Text(
            'L O G I N',
            style: TextStyle(
              fontFamily: 'italiana',
              fontSize: AppDimensions.d50,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = AppColors.colorBlack,
            ),
          ),
          const Text(
            'L O G I N',
            style: TextStyle(
              fontFamily: 'italiana',
              fontSize: AppDimensions.d50,
              color: AppColors.colorWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
  }) {
    return Center(
      child: SizedBox(
        width: AppDimensions.d500,
        child: TextFormField(
          controller: controller,
          style: const TextStyle(color: AppColors.colorBlack),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            FocusScope.of(context).nextFocus();
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            fillColor: AppColors.colorGrey,
            filled: true,
            prefixIcon: Icon(icon),
            labelText: label,
            labelStyle: const TextStyle(color: AppColors.colorBlack),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 3,
                color: AppColors.primaryColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(AppDimensions.d50)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(CubitClass cub) {
    return Center(
      child: Container(
        height: AppDimensions.d70,
        width: AppDimensions.d270,
        decoration: const BoxDecoration(
          color: AppColors.colorWhite70,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppDimensions.d200),
            topLeft: Radius.circular(AppDimensions.d20),
            bottomRight: Radius.circular(AppDimensions.d20),
            topRight: Radius.circular(AppDimensions.d200),
          ),
        ),
        child: MaterialButton(
          onPressed: () async {
            _onLoginPressed(cub);
          },
          child: ShimmerEffect(
            baseColor: AppColors.primaryColor,
            highlightColor: AppColors.primaryColor3,
            child: Ink(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.d20),
                  bottomLeft: Radius.circular(AppDimensions.d200),
                  topRight: Radius.circular(AppDimensions.d200),
                  bottomRight: Radius.circular(AppDimensions.d20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    AppColors.primaryColor3,
                    AppColors.primaryColor,
                  ],
                ),
              ),
              child: const SizedBox(
                height: AppDimensions.d50,
                width: AppDimensions.d250,
                child: Center(
                  child: Text(
                    AppTexts.login,
                    style: TextStyle(fontSize: AppDimensions.d25),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginPressed(CubitClass cub) async {

    bool isValid = formKey.currentState?.validate() ?? false;

    if (isValid) {
      try {
        await cub.firebaseLogin(
          email: emailController.text,
          password: passController.text,
        );
      }catch (e){
        showNotification(
          context: context,
          contentType: ContentType.failure,
          title: 'oops !!',
          message: 'there is a problem ...try again later',
        );
      }
      }
    //
    //     bool isLoggedIn = SharedPref.getBoolData('isLogin') ?? false;
    //     Navigator.of(context).pop();
    //     if (isLoggedIn) {
    //       navigatorReplace(context, MainPage());
    //     }
    //   } catch (e) {
    //     Navigator.of(context).pop();
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Login failed. Please try again.')),
    //     );
    //   }
    // } else {
    //   Navigator.of(context).pop();
    // }
  }
}
