import 'dart:io';import 'dart:io';
import 'package:cinema/backend/dio.dart';
import 'package:cinema/backend/shared_pref.dart';
import 'package:cinema/models/guest.dart';
import 'package:cinema/models/movie.dart';
import 'package:cinema/models/ticket.dart';
import 'package:cinema/state_management/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfFile;

import '../components/constants.dart';

class CubitClass extends Cubit<AppState> {
  CubitClass() : super(InitCubit());

  static CubitClass get(context) => BlocProvider.of<CubitClass>(context);

  ThemeData? themeData = light;
  bool isDark = false;

  /// Toggles between light and dark themes based on system preference.
  ThemeData? toggleLightAndDark(context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    brightness == Brightness.dark
        ? (themeData = dark, isDark = true)
        : (themeData = light, isDark = false);
    emit(ToggleLightAndDark());
    return themeData;
  }

  final _auth = FirebaseAuth.instance;

  /// Authenticates the user with Firebase using email and password.
  Future<void> firebaseLogin({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      SharedPref.setBoolData('isLogin', true);
    });
  }

  /// Logs the user out from Firebase.
  Future<void> firebaseLogOut() async {
    await _auth.signOut();
    emit(FirebaseLogOut());
  }

  List<Guest> guests = [];

  /// Retrieves the list of guests from the backend.
  Future<void> getGuests() async {
    guests.clear();
    await DioHelper.getData('viewsets/guests/').then((value) {
      var responseData = value!.data;
      for (var item in responseData) {
        guests.add(Guest.fromJson(item));
      }
      emit(GetGuests());
      if (kDebugMode) print('Guests Loaded: ${guests.length}');
    }).catchError((error) {
      if (kDebugMode) print('Error Guest: $error');
    });
  }

  List<Movie> movies = [];

  /// Fetches the list of movies from the backend.
  Future<void> getMovies() async {
    movies.clear();
    await DioHelper.getData('viewsets/movies/').then((value) {
      var responseData = value!.data;
      for (var item in responseData) {
        movies.add(Movie.fromJson(item));
      }
      emit(GetMovies());
      if (kDebugMode) print('Movies Loaded: ${movies.length}');
    }).catchError((error) {
      if (kDebugMode) print('Error Movies: $error');
    });
  }

  List<Reservation> reservations = [];

  /// Retrieves all reservations from the backend.
  Future<void> getReservations() async {
    reservations.clear();
    await DioHelper.getData('viewsets/reservations/').then((response) {
      if (response != null && response.data != null) {
        for (var item in response.data) {
          reservations.add(Reservation.fromJson(item));
        }
        print('Reservations loaded: ${reservations.length}');
        emit(GetReservations());
      }
    }).catchError((e) {
      if (kDebugMode) print('Error Reservations: ${e.toString()}');
    });
  }

  List<Reservation> filteredReservations = [];

  /// Filters reservations by movie ID.
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

  /// Searches for movies by a given keyword.
  void searchMovies({required String word}) {
    searchedMovie.clear();
    DioHelper.getData('viewsets/movies/', queryParameters: {'search': word})
        .then((value) {
      for (var item in value!.data!) {
        searchedMovie.add(Movie.fromJson(item));
      }
      emit(SearchMovieSuccess());
    }).catchError((e) {
      emit(SearchMovieError(error: e.toString()));
    });
  }

  bool isSearchingMovie = false;
  bool cornerExpanded = false;
  bool empExpanded = false;

  /// Toggles the movie search mode.
  movieSearch() {
    isSearchingMovie = !isSearchingMovie;
    emit(IsSearching());
  }

  bool isSearchReservation = false;

  /// Toggles the reservation search mode.
  reservationSearch() {
    isSearchReservation = !isSearchReservation;
    emit(IsSearching());
  }

  /// Expands or collapses the corner section.
  agCornerExpanded() {
    cornerExpanded = !cornerExpanded;
    emit(CornerExpanded());
  }

  /// Expands or collapses the employee section.
  agEmpExpanded() {
    empExpanded = !empExpanded;
    emit(EmpExpanded());
  }

  /// Adds a new reservation with the provided details.
  Future<void> addReservation({
    required Movie movie,
    required String name,
    required int age,
    required List<String> seats,
    required int reservations,
  }) async {
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
      if (kDebugMode) print('Error: ${e.toString()}');
    });
  }

  /// Edits the movie details and updates the backend.
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
      'available_seats': seats - reservedSeats.length,
      'ticket_price': ticketPrice,
      'photo': photo,
      'reservedSeats': reservedSeats
    }).then((value) {
      getMovies();
      emit(EditMovieSuccess());
    }).catchError((e) {
      emit(EditMovieError(error: e.toString()));
    });
  }

  /// Adds a new movie to the backend.
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

  /// Deletes a movie and its related reservations from the backend.
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
            if (kDebugMode) print('Error: ${e.toString()}');
            emit(DeleteMovieError());
          });
        });
      }
    });
  }

  bool isUploading = false;
  File? movieImage;
  String? movieImageUrl;

  /// Toggles the upload state for a movie image.
  void isUploadingImage() {
    isUploading = !isUploading;
    emit(IsSearching());
  }

  /// Allows picking an image for the movie and uploads it.
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
        if (kDebugMode) print('No Image Selected');
        emit(GetMovieImageUrlFailed());
      }
    }
  }

  Future<void> uploadBackgroundPhoto({
    required File? image,
    required Movie movie,
  }) async {
    // Uploads the background photo to Firebase Storage
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

  Future<void> _deletePreviousPhoto({
    required String image,
  }) async {
    // Deletes the previous photo from Firebase Storage
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
      // Parse the string to a double value
      String trimmedText = text.trim().replaceAll(',', '.');

      if (trimmedText.isEmpty) {
        print('Error: Empty input');
        return null;
      }

      double value = double.parse(trimmedText);
      print('Parsed value: $value');
      return value;
    } catch (e) {
      print('Error parsing double: $e');
      return null;
    }
  }

  File? newMovieImage;
  String? newMovieImageUrl;

  /// Picks a new image from the device
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

  /// Uploads the selected image to Firebase Storage
  Future<void> uploadMoviePhoto(File newMovieImage) async {
    try {
      String fileName = Uri.file(newMovieImage.path).pathSegments.last;
      Reference storageReference =
      FirebaseStorage.instance.ref().child('movies/$fileName');

      UploadTask uploadTask = storageReference.putFile(newMovieImage);

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

  /// Generates a PDF ticket and opens it
  Future<void> generateAndPrintPDF({
    required String name,
    required String totalPayment,
    required String ticketPrice,
    required List<String> seats,
    required String movieTitle,
    required String hall,
    required String reservationCode,
  }) async {
    final pdf = pdfFile.Document();

    final ByteData imageData =
    await rootBundle.load('assets/images/just4prog.png');
    final Uint8List imageBytes = imageData.buffer.asUint8List();

    final image = pdfFile.MemoryImage(imageBytes);
    final logo = pdfFile.SizedBox(
        width: AppDimensions.d300,
        height: AppDimensions.d150,
        child: pdfFile.Image(image));

    pdf.addPage(
      pdfFile.Page(
        build: (pdfFile.Context context) => pdfFile.Center(
          child: pdfFile.Column(
            crossAxisAlignment: pdfFile.CrossAxisAlignment.start,
            children: [
              pdfFile.Center(child: logo),
              pdfFile.SizedBox(height: 10),
              pdfFile.Row(crossAxisAlignment: pdfFile.CrossAxisAlignment.start, children: [
                pdfFile.Column(
                  crossAxisAlignment: pdfFile.CrossAxisAlignment.start,
                  children: [
                    pdfFile.Text('Movie: $movieTitle'),
                    pdfFile.Text('Name: $name'),
                    pdfFile.Text('Seats: $seats'),
                    pdfFile.Text('Total Payment: $totalPayment \$'),
                    pdfFile.Text('Reservation Code: $reservationCode'),
                  ],
                ),
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

  bool isEditingGuest = false;

  /// Toggles the guest editing mode
  editingGuest() {
    isEditingGuest = !isEditingGuest;
    emit(EditingGuest());
  }

  /// Updates a guest's reservation and adjusts the movie's reserved seats
  Future<void> updateReservation({
    required String? fullName,
    required int? reservations,
    required int? age,
    required List<String>? seats,
    required Reservation reservation,
    required int? movieId,
  }) async {
    // Remove old seats from the reserved list
    for (String item in reservation.guest!.seats!) {
      reservation.movie!.reservedSeats!.removeWhere((seat) => seat == item);
    }

    // Add new seats, avoiding duplicates
    List<String> newReservedSeats =
    List.from(reservation.movie!.reservedSeats!);
    newReservedSeats
        .addAll(seats!.where((seat) => !newReservedSeats.contains(seat)));

    // Update the reservation details
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
          "reservedSeats": newReservedSeats,
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
      print('Error editing guest: ${e.toString()}');
    });
  }

}
