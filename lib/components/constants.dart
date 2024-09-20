import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color colorBlue = Colors.blue;
  static const Color colorBlack = Colors.black;
  static const Color colorOrange = Colors.orange;
  static const Color colorWhite = Colors.white;
  static const Color colorRed = Colors.red;
  static const Color colorGreen = Colors.green;
  static const Color colorOrangeAccent = Colors.orangeAccent;
  static const Color colorDeepOrange = Colors.deepOrange;
  static const Color colorGrey = Colors.grey;
  static const Color colorBlueAccent = Colors.blueAccent;
  static const Color primaryColor = Color(0xFF40E0D0);
  static const Color primaryColor3 = Color(0xFF53529F);
  static const Color primaryColor4 =  Color(0xFFFFDAB9);
  static const Color colorPrPurple = Color(0xFF9A9ACD);
  static const Color colorWhite70 = Color(0xB3FFFFFF);
  static const Color defaultBlueColor = Color(0xFF40E0D0);
  static const Color defaultPurpleColor = Color(0xFF8A2BE2);
  static const Color primaryColor2 = Color(0xFFF08080);

  List<Color> myColorList = [
    const Color(0xFFFFF0F5), // Lavender Blush
    const Color(0xFFFFDAB9), // Peach Puff
    const Color(0xFF7FFFD4), // Aqua Marine
    const Color(0xFF6495ED), // Cornflower Blue
    const Color(0xFFFFEFD5), // Papaya Whip
    const Color(0xFFFFF5EE), // Sea Shell
    const Color(0xFFE6E6FA), // Lavender
    const Color(0xFFF08080), // Light Coral
    const Color(0xFF7B68EE), // Medium Slate Blue
    const Color(0xFFEEE8AA), // Pale Goldenrod
  ];

}

class AppTexts {
  static const String searchHint = 'Search...';
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String edit = 'Edit';
  static const String tickets = 'Tickets';
  static const String ticketPrice = 'Ticket Price';
  static const String addMovie = 'Add Movie';
  static const String reservations = 'Reservations';
  static const String movieTitle = 'Movie Title';
  static const String movies = 'Movies';
  static const String movieHall = 'Movie Hall';
  static const String allSeats = 'All Seats';
  static const String date = 'Date';
  static const String time = 'Time';
  static const String reservation = 'Reservation';
  static const String totalPayment = 'Total Payment';
  static const String deleteMovie = 'Delete Movie';
  static const String seats = 'Seats';
  static const String availableSeats = 'Available Seats';
  static const String reservedSeats = 'Reserved Seats';
  static const String price = 'Price';
  static const String age = 'Age';
  static const String name = 'Full Name';
  static const String print = 'Print';
  static const String reservationCode = 'Reservation Code';
  static const String uploadImage = 'Upload Image';
  static String assetsImage (String imageName){
    return 'assets/images/$imageName';
  }
}

class AppDimensions {
  //integers
  static const int m1 = 1;

  static const int m20 = 20;

  static const int m15 = 15;
  static const int m30 = 30;

  static const int m25 = 25;
  static const int m5 = 5;
  static const int m120 = 120;
  static const int m50 = 50;
  static const int m0 = 0;
  static const int m2 = 2;
  static const int m40 = 40;
  static const int m8 = 8;
  static const int m60= 60;

//double
  static const double d1 = 1;
  static const double d500 = 500;
  static const double d250 = 250;
  static const double d100 = 100;
  static const double d145 = 145;
  static const double d200 = 200;
  static const double d300 = 300;
  static const double d150 = 150;
  static const double d270 = 270;
  static const double d70 = 70;
  static const double d2 = 2;
  static const double d8 = 8;
  static const double d0 = 0;
  static const double d40 = 40;
  static const double d60= 60;
  static const double d30 = 30;
  static const double d50 = 50;
  static const double d15 = 15;
  static const double d10 = 10;
  static const double d5 = 5;
  static const double d25 = 25;
  static const double d20 = 20;
  static const double d120 = 120;

//double x,00
  static const double d015 = 0.15;

  static const double d025 = 0.25;
}
class AppTextStyles{
  static const TextStyle titlesStyle =  TextStyle(
    color: AppColors.primaryColor,
    fontSize: 30 ,
    fontFamily: 'freedom'
  );
  static const TextStyle bodyStyle =  TextStyle(
    color: AppColors.primaryColor4,
    fontSize: 21,
    fontFamily: 'italiana',
      fontWeight: FontWeight.bold
  );
  static const TextStyle labelStyle =  TextStyle(
    color: AppColors.defaultBlueColor,
    fontSize: 18 ,
    fontFamily: 'monospace'
  );

  static const TextStyle labelStyleOrange  =  TextStyle(
    color: AppColors.colorDeepOrange,
    fontSize: 18 ,
    fontFamily: 'monospace'
  );
  static const TextStyle descStyle =  TextStyle(
    color: AppColors.primaryColor3,
    fontSize: 14 ,
    fontFamily: 'cool'
  );

}

ThemeData? myTheme({
  required Color shadowColor,
  required Color appBarBackgroundColor,
  required Color statusBarColor,
  required Brightness statusBarBrightness,
  required Brightness statusBarIconBrightness,
  required Color scaffoldBackgroundColor,
  required Color appBarIconColor,
  required double titleFontSize,
  required Color textColor,
  required Color selectedItemColor,
  required Color unselectedItemColor,
  required Color ifIconPressingColor,
  required Color iconInIconButtonColor,
}) {
  return ThemeData(

    listTileTheme: ListTileThemeData(
      textColor: textColor,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return ifIconPressingColor;
          }
          return iconInIconButtonColor;
        }),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: unselectedItemColor,
      backgroundColor: scaffoldBackgroundColor,
      type: BottomNavigationBarType.fixed,
      elevation: 0.9,
      selectedItemColor: selectedItemColor,
      showSelectedLabels: false,
    ),
    shadowColor: shadowColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarColor: statusBarColor,
      ),
      shadowColor: shadowColor,
      backgroundColor: appBarBackgroundColor,
      centerTitle: true,
      iconTheme: IconThemeData(color: appBarIconColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: titleFontSize,
      ),
    ),
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: textColor),
      bodyLarge: TextStyle(color: textColor),
      bodySmall: TextStyle(color: textColor),
    ),
  );
}

ThemeData? dark = myTheme(

  selectedItemColor: Colors.greenAccent,

  unselectedItemColor: Colors.grey,
  shadowColor: Colors.white,
  appBarBackgroundColor: Colors.black,
  statusBarColor: Colors.black,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  scaffoldBackgroundColor: Colors.black,
  textColor: Colors.white,
  appBarIconColor: Colors.white,
  titleFontSize: 30,
  iconInIconButtonColor: Colors.deepOrange,
  ifIconPressingColor: Colors.white,

);
ThemeData? light = myTheme(
  selectedItemColor: Colors.deepOrange,
  unselectedItemColor: Colors.black,
  shadowColor: Colors.black,
  appBarBackgroundColor: Colors.white,
  statusBarColor: Colors.white,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.white,
  textColor: Colors.black,
  appBarIconColor: Colors.black,
  titleFontSize: 30,
  iconInIconButtonColor: Colors.deepOrange,
  ifIconPressingColor: Colors.grey,
);

navigatorTo(context, nextPage) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextPage,
      ));
}

navigatorReplace(context, nextPage) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => nextPage,
      ));
}

class CustomShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.pink.shade400;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.cubicTo(size.width * 0.4, size.height * 0.75, size.width * 0.2,
        size.height * 0.02, size.width * 0.35, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void showNotification({
  required BuildContext context,
  required ContentType contentType,
  String? title,
  String? message,
}) {
  final materialBanner = MaterialBanner(
    /// need to seat following properties for best effect of awesome_snackbar_content
    elevation: 0,
    backgroundColor: Colors.transparent,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      title: title ?? 'Oh Hey!!',
      message: message ?? 'Everything updated',

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: contentType,
      // to configure for material banner
      inMaterialBanner: true,
    ),
    actions: const [SizedBox.shrink()],
  );

  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // Show the MaterialBanner
  scaffoldMessenger
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(materialBanner);

  // Automatically hide the MaterialBanner after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    scaffoldMessenger.hideCurrentMaterialBanner();
  });
}
Widget buildTextFormField({
  required String label,
  required TextEditingController controller,
  bool readOnly = false,
  Function(String)? onChanged,
  TextInputType? keyboardType,
  Widget? suffix,
}) {
  return TextFormField(
      keyboardType: keyboardType ?? TextInputType.text,
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      decoration: InputDecoration(
          suffix: suffix,
          labelText: label,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.colorWhite,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.d5),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.d20),
              topRight: Radius.circular(AppDimensions.d20),
            ),
            borderSide: BorderSide(
              color: AppColors.colorOrange,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppDimensions.d20),
              bottomRight: Radius.circular(AppDimensions.d20),
            ),
            borderSide: BorderSide(
              color: AppColors.colorWhite,
            ),
          ),
          labelStyle: AppTextStyles.labelStyle,
          hintStyle: AppTextStyles.descStyle),
      style: AppTextStyles.descStyle);
}