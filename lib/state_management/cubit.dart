import 'dart:io';

import 'package:cinema/backend/dio.dart'; // Importing custom Dio helper for handling API requests
import 'package:cinema/backend/shared_pref.dart'; // Importing shared preferences helper for local data storage
import 'package:cinema/models/guest.dart'; // Importing the Guest model class
import 'package:cinema/models/movie.dart'; // Importing the Movie model class
import 'package:cinema/models/ticket.dart';
import 'package:cinema/state_management/states.dart'; // Importing different app states used by the Cubit
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importing Firebase Authentication for user login
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // Importing foundation utilities like debug mode check (kDebugMode)
import 'package:flutter/material.dart'; // Importing Flutter’s material design components
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfFile;

import '../components/constants.dart'; // Importing Bloc for state management

class CubitClass extends Cubit<AppState> {
  CubitClass()
      : super(
            InitCubit()); // Initializing the Cubit with the initial state (InitCubit)

  // Creating a static instance of the Cubit class for easy access throughout the app
  static CubitClass get(context) => BlocProvider.of<CubitClass>(context);

  // Toggle between light and dark mode based on device brightness settings
  ThemeData? themeData = light; // Default theme is seat to light mode
  bool isDark = false; // Boolean to track if the app is in dark mode

  // Method to toggle between light and dark theme based on system settings
  ThemeData? toggleLightAndDark(context) {
    Brightness brightness = MediaQuery.of(context)
        .platformBrightness; // Check current system brightness
    brightness == Brightness.dark
        ? (
            themeData = dark,
            isDark = true
          ) // If system is in dark mode, apply dark theme
        : (themeData = light, isDark = false); // Else, apply light theme
    emit(ToggleLightAndDark()); // Emit the state change to notify listeners
    return themeData; // Return the theme data to update the UI
  }

  // Firebase Authentication instance for handling login
  final _auth = FirebaseAuth.instance;

  // Method to handle Firebase login using email and password
  Future<void> firebaseLogin({
    required String email, // User email for login
    required String password, // User password for login
  }) async {
    await _auth
        .signInWithEmailAndPassword(
            email: email, password: password) // Sign in using Firebase
        .then((value) {
      SharedPref.setBoolData('isLogin',
          true); // Set login state in shared preferences after successful login
    });
  }
  Future<void> firebaseLogOut()async {
    await _auth.signOut();
    emit(FirebaseLogOut());
  }

  // Handling API requests for fetching guest data
  List<Guest> guests = []; // List to store guests fetched from the API

  // Method to fetch guest data from API using DioHelper
  Future<void> getGuests()async {
    guests.clear(); // Clear the current list before fetching new data
   await DioHelper.getData('viewsets/guests/').then((value) {
      var responseData = value!.data; // Parse the response data from API
      for (var item in responseData) {
        item = Guest.fromJson(item); // Convert each item to a Guest object
        guests.add(item); // Add each guest to the list
      }
      emit(
          GetGuests()); // Emit the state to notify the app that guests have been fetched
      if (kDebugMode) {
        print(
            'Guests Loaded: ${guests.length}'); // Debug log showing the number of guests loaded
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error Guest:  $error'); // Log error if the API request fails
      }
    });
  }

  // Handling API requests for fetching movie data
  List<Movie> movies = []; // List to store movies fetched from the API

  // Method to fetch movie data from API using DioHelper
  Future<void> getMovies() async{
    movies.clear(); // Clear the current list before fetching new data
    await DioHelper.getData('viewsets/movies/').then((value) {
      var responseData = value!.data; // Parse the response data from API
      for (var item in responseData) {
        var movie = Movie.fromJson(item); // Convert each item to a Movie object
        movies.add(movie); // Add each movie to the list
      }
      emit(
          GetMovies()); // Emit the state to notify the app that movies have been fetched
      if (kDebugMode) {
        print(
            'Movies Loaded: ${movies.length}'); // Debug log showing the number of movies loaded
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error Movies: $error'); // Log error if the API request fails
      }
    });
  }

  List<Reservation> reservations = [];

  Future<void> getReservations()async {
    reservations.clear();
   await DioHelper.getData('viewsets/reservations/').then((response) {
      // تحليل البيانات من الـ JSON وتحويلها إلى كائنات Dart
      if (response != null && response.data != null) {
        // تحويل كل عنصر في القائمة القادمة من الـ JSON إلى كائن Reservation
        for (var item in response.data) {
          reservations.add(Reservation.fromJson(item));
        }
        print('Reservations loaded: ${reservations.length}');
        emit(GetReservations()); // عرض الحالة الجديدة
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error Reservations : ${e.toString()}');
      }
    });
  }

  List<Reservation> filteredReservations = [];

  Future<void> filterReservationsByMovie(int movieId) async {
    filteredReservations.clear();
    for (Reservation reservation in reservations) {
      if (reservation.movie?.id == movieId) {
        filteredReservations.add(reservation);
      }
    }
    emit(FilterReservationsByMovie());
  }

  List<Movie> searchedMovie = [];

  void searchMovies({required String word}) {
    searchedMovie.clear(); // Clear previous search results
    DioHelper.getData('viewsets/movies/', queryParameters: {'search': word})
        .then((value) {
      for (var item in value!.data!) {
        var movie = Movie.fromJson(
            item); // Convert each search result to a Movie object
        searchedMovie.add(movie); // Add the result to the search results list
      }
      emit(
          SearchMovieSuccess()); // Emit success state when search is successful
    }).catchError((e) {
      emit(SearchMovieError(
          error: e.toString())); // Emit error state if search fails
    });
  }

  // Main page state management variables and methods
  bool isSearchingMovie = false; // Track if search mode is active
  bool cornerExpanded = false; // Track if corner UI component is expanded
  bool empExpanded = false; // Track if another UI component is expanded

  // Method to toggle search mode
  movieSearch() {
    isSearchingMovie = !isSearchingMovie; // Toggle search mode
    emit(IsSearching()); // Emit the state change
  }

  bool isSearchReservation = false;

  reservationSearch() {
    isSearchReservation = !isSearchReservation; // Toggle search mode
    emit(IsSearching()); // Emit the state change
  }

  // Method to toggle the corner UI component expansion
  agCornerExpanded() {
    cornerExpanded = !cornerExpanded; // Toggle expansion of corner component
    emit(CornerExpanded()); // Emit the state change
  }

  // Method to toggle Employee Details UI component expansion
  agEmpExpanded() {
    empExpanded = !empExpanded; // Toggle expansion of emp component
    emit(EmpExpanded()); // Emit the state change
  }

  Future<void> addReservation(
      {required Movie movie,
      required String name,
      required int age,
      required List<String> seats,
      required int reservations}) async {
    await DioHelper.postData(methodUrl: 'viewsets/reservations/', data: {
      "movie": {
        "name": movie.name,
        "date": movie.date,
        "time": movie.time,
        "hall": movie.hall,
        "seats": movie.seats,
        "available_seats": movie.availableSeats,
        "ticket_price": movie.ticketPrice
      },
      "guest": {
        "movie_id": movie.id,
        "full_name": name,
        "age": age,
        "seats": seats,
        "reservations": reservations
      },
    }).then((value) {
      getReservations();
      getGuests();
      getMovies();
      emit(ReservedSuccess());
    }).catchError((e) {
      emit(ReservedError(e.toString()));
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    });
  }

  // edit movie >>

  Future<void> editMovie({
    required String name,
    required String date,
    required String hall,
    required String time,
    required int seats,
    required int availableSeats,
    required double ticketPrice,
    required String photo,
    required Movie movie,
    required int reservations,
    required List<String> reservedSeats,
  }) async {
    await DioHelper.putData(methodUrl: 'viewsets/movies/${movie.id}/', data: {
      'name': name,
      'date': date,
      'time': time,
      'hall': hall,
      'seats': seats,
      'Available Seats': availableSeats,
      'ticket_price': ticketPrice,
      'reservations': movie.reservations,
      'photo': photo,
      'reservedSeats': reservedSeats
    }).then((value) {
      getMovies();
      emit(EditMovieSuccess());
    }).catchError((e) {
      emit(EditMovieError(error: e.toString()));
    });
  }

  //add Movie

  Future<void> addMovie({
    required String name,
    required String date,
    required String time,
    required String hall,
    required int seats,
    required double ticketPrice,
    required String photo,
  }) async {
    await DioHelper.postData(methodUrl: 'viewsets/movies/', data: {
      "name": name,
      "photo": photo,
      "date": date,
      "time": time,
      "hall": hall,
      "seats": seats,
      "available_seats": seats,
      "reserved Seats": 0,
      "reservations": 0,
      "ticket_price": ticketPrice,
    }).then((value) {
      emit(AddMovieSuccess());
    }).catchError((value) {
      emit(AddMovieError());
    });
  }

  //delete movie
  deleteMovie({required Movie movie}) {
    filterReservationsByMovie(movie.id!).then((value) async {
      for (Reservation reservation in filteredReservations) {
        await DioHelper.deleteData('viewsets/guests/${reservation.guest!.id}/')
            .then((value) async {
          await DioHelper.deleteData('viewsets/movies/${movie.id}/')
              .then((value) {
            getMovies();
            emit(DeleteMovieSuccess());
          }).catchError((e) {
            if (kDebugMode) {
              print('Error : ${e.toString()}');
            }
            emit(DeleteMovieError());
          });
        });
      }
    });
  }

  //photo handling

  bool isUploading = false;
  File? movieImage;
  String? movieImageUrl;

  void isUploadingImage() {
    isUploading = !isUploading; // Toggle upload state
    emit(IsSearching()); // Emit state change
  }

  Future<void> imagePicker({required Movie movie}) async {
    if (Platform.isWindows) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        movieImage = File(result.files.single.path!);
        emit(UploadingMovieImage());
        await uploadBackgroundPhoto(image: movieImage, movie: movie);
        emit(GetMovieImageUrlSuccess());
      } else {
        if (kDebugMode) {
          print('No Image Selected');
        }
        emit(GetMovieImageUrlFailed());
      }
    } else {
      // Handle image picking for mobile or other platforms if necessary
    }
  }

  Future<void> uploadBackgroundPhoto(
      {required File? image, required Movie movie}) async {
    // if (movie.photo != null) {
    //   await _deletePreviousPhoto(image: movie.photo!);
    // }

    if (image == null) return;

    await FirebaseStorage.instance
        .ref(
            'movies/photos/movie_id_:${movie.id}${Uri.file(image.path).pathSegments.last}')
        .putFile(image)
        .then((value) {
      value.ref.getDownloadURL().then((url) {
        movieImageUrl = url;
        emit(UploadedSuccess());
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> _deletePreviousPhoto({required String image}) async {
    try {
      await FirebaseStorage.instance.refFromURL(image).delete();
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting previous photo: $error');
      }
    }
  }

  double? parseDouble(String text) {
    try {
      // إزالة أي مسافات بيضاء حول النص
      String trimmedText = text.trim();

      // استبدال الفواصل بالنقاط
      trimmedText = trimmedText.replaceAll(',', '.');

      // تحقق إذا كان النص ليس فارغًا
      if (trimmedText.isEmpty) {
        print('Error: Empty input');
        return null;
      }

      // محاولة تحويل النص إلى double
      double value = double.parse(trimmedText);

      // التحقق من القيم
      print('Parsed value: $value');

      return value;
    } catch (e) {
      // في حالة حدوث خطأ، يمكنك التعامل مع الاستثناء هنا (مثل تسجيل الأخطاء)
      print('Error parsing double: $e');
      return null;
    }
  }

  File? newMovieImage;
  String? newMovieImageUrl;

  Future<void> pickNewImage() async {
    emit(PickingNewImage());
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      isUploadingImage();
      newMovieImage = File(result.files.single.path!);
      uploadMoviePhoto(newMovieImage!);
    } else {
      if (kDebugMode) {
        print('No Image Selected');
      }
    }
  }

  Future<void> uploadMoviePhoto(File newMovieImage) async {
    try {
      String fileName = Uri.file(newMovieImage.path).pathSegments.last;
      Reference storageReference =
          FirebaseStorage.instance.ref().child('movies/$fileName');

      // رفع الصورة إلى Firebase Storage
      UploadTask uploadTask = storageReference.putFile(newMovieImage);

      // الحصول على رابط التحميل للصورة
      await uploadTask.whenComplete(() async {
        newMovieImageUrl = await storageReference.getDownloadURL();
        isUploadingImage();

        emit(PickNewImageSuccess());
        if (kDebugMode) {
          print('Image URL: $movieImageUrl');
        }
      });

      if (kDebugMode) {
        print('File uploaded');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> generateAndPrintPDF(
      {required String name,
      required String totalPayment,
      required String ticketPrice,
      required List<String> seats,
      required String movieTitle,
      required String hall,
      required String reservationCode}) async {
    final pdf = pdfFile.Document();
    // تحميل الصورة من assets كـ Uint8List
    final ByteData imageData =
        await rootBundle.load('assets/images/just4prog.png');
    final Uint8List imageBytes = imageData.buffer.asUint8List();

    // تحويل الصورة إلى MemoryImage
    final image = pdfFile.MemoryImage(imageBytes);
    final logo = pdfFile.SizedBox(width: AppDimensions.d300 , height: AppDimensions.d150 , child: pdfFile.Image(image));

    pdf.addPage(
      pdfFile.Page(
        build: (pdfFile.Context context) => pdfFile.Center(
          child: pdfFile.Column(
            crossAxisAlignment: pdfFile.CrossAxisAlignment.start,
            children: [
              pdfFile.Center(child:logo ),
              pdfFile.SizedBox(height: 10),
              pdfFile.Row(
                  crossAxisAlignment: pdfFile.CrossAxisAlignment.start,
                  children: [
                      pdfFile.Column(
                          crossAxisAlignment: pdfFile.CrossAxisAlignment.start,
                          children: [
                            pdfFile.Text('Movie: $movieTitle'),
                            pdfFile.Text('Name: $name'),
                            pdfFile.Text('Seats: $seats'),
                            pdfFile.Text('Total Payment: $totalPayment \$'),
                            pdfFile.Text('Reservation Code: $reservationCode'),
                          ]),
                  ]),
            ],
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/ticket.pdf");

    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
    if (kDebugMode) {
      print("PDF Saved to ${file.path}");
    }
  }


  bool isEditingGuest = false ;
  editingGuest(){
    isEditingGuest = !isEditingGuest;
    emit(EditingGuest());
  }
  Future<void> updateReservation({
    required String? fullName,
    required int? reservations,
    required int? age,
    required List<String>? seats,
    required Reservation reservation,
    required int? movieId
  }) async {
    // 1. إزالة المقاعد القديمة الخاصة بالضيف من القائمة المحجوزة في الفيلم
    for (String item in reservation.guest!.seats!) {
      reservation.movie!.reservedSeats!.removeWhere((seat) => seat == item);
    }

    // 2. دمج المقاعد الجديدة مع المقاعد المحجوزة الأخرى (تجنب التكرار)
    List<String> newReservedSeats = List.from(reservation.movie!.reservedSeats!);
    newReservedSeats.addAll(seats!.where((seat) => !newReservedSeats.contains(seat)));

    // 3. إرسال الطلب لتحديث الحجز
    await DioHelper.putData(
      methodUrl: 'viewsets/reservations/${reservation.reservationId}/',
      data: {
        "movie": {
          "id": movieId,
          "name": reservation.movie!.name,
          "date": reservation.movie!.date,
          "time": reservation.movie!.time,
          "hall": reservation.movie!.hall,
          "seats": reservation.movie!.seats,
          "photo": reservation.movie!.photo,
          "ticket_price": reservation.movie!.ticketPrice,
          "reservedSeats": newReservedSeats, // استخدم القائمة المحدثة هنا
        },
        "guest": {
          "id": reservation.guest!.id,
          "movie_id": reservation.movie!.id,
          "full_name": fullName,
          "age": age,
          "reservations": reservations,
          "seats": seats,
        },
      },
    ).then((value) {
      getReservations();
      getGuests();
      getMovies();
      emit(UpdateReservationSuccess());
    }).catchError((e) {
      emit(UpdateReservationError(error: e));
      print('Error edit guest : ${e.toString()}');
    });
  }

}
