import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cinema/main.dart';
import 'package:cinema/ui/add_reservation.dart';
import 'package:cinema/ui/edit_movie.dart';
import 'package:cinema/ui/reservations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/constants.dart';
import '../models/movie.dart';
import '../state_management/cubit.dart';
import '../state_management/states.dart';

// StatefulWidget used to edit the details of a movie
class MovieDetails extends StatefulWidget {
  // This holds the movie data that will be edited. It can be null if we're creating a new movie
  final Movie movie;

  // Constructor that initializes the widget with the movie object
  const MovieDetails({super.key, required this.movie});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  // Controllers for handling text input in form fields
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _hallController;
  late TextEditingController _timeController;
  late TextEditingController _reservationController;
  late TextEditingController _setsController;
  late TextEditingController _priceController;
  late TextEditingController _reservedSeatsController;
  late TextEditingController _availableSeats;

  @override
  Widget build(BuildContext context) {
    // Initialize text controllers with existing movie data if it's available
    // These controllers will display the movie's current details, allowing the user to edit them
    _nameController = TextEditingController(text: widget.movie.name);
    _dateController = TextEditingController(text: widget.movie.date ?? '');
    _hallController = TextEditingController(text: widget.movie.hall);
    _timeController = TextEditingController(text: widget.movie.time ?? '');
    _reservedSeatsController = TextEditingController(
        text: widget.movie.reservedSeats!.length.toString());
    _reservationController = TextEditingController(
        text: widget.movie.reservations?.toString() ?? '');
    _setsController =
        TextEditingController(text: widget.movie.seats?.toString() ?? '');
    _availableSeats = TextEditingController(
        text: widget.movie.availableSeats?.toString() ?? '');
    _priceController = TextEditingController(
        text: widget.movie.ticketPrice?.toString() ?? '');

    // Access the Cubit class for managing state in the app
    CubitClass cub = CubitClass.get(context);

    // BlocConsumer listens to changes in the Cubit state and reacts accordingly
    // The builder function handles how the UI is displayed based on the state
    return BlocConsumer<CubitClass, AppState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              // This button allows the user to navigate back to the previous screen
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        // Main content of the screen is a row that splits into two parts:
        // 1. A fixed image (the movie poster)
        // 2. A scrollable section containing the form for editing movie details
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed left section containing the movie poster image
            SizedBox(
              width: MediaQuery.of(context).size.width * AppDimensions.d025,
              height: MediaQuery.of(context).size.height * AppDimensions.d025,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppDimensions.d5)),
                child: Image.network(
                  widget.movie.photo!,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(
              width: AppDimensions.d50,
            ),

            // Scrollable right section for editing the movie's details
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.d15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              navigatorTo(
                                  context, Reservations(movie: widget.movie));
                            },
                            child: SizedBox(
                              width:
                              MediaQuery.of(context).size.width * (1 / 8),
                              height: AppDimensions.d50,
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        (1 / 8),
                                    height: AppDimensions.d50,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorBlueAccent,
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.d5),
                                    ),
                                    child: const Align(
                                      alignment: Alignment(-0.6, 0),
                                      child: Text(AppTexts.tickets,
                                          style: AppTextStyles.bodyStyle),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      height: AppDimensions.d50,
                                      width:
                                      (MediaQuery.of(context).size.width *
                                          (1 / 8)) /
                                          3,
                                      child: CustomPaint(
                                        painter: CustomShape(),
                                        child: Center(
                                          child: Transform.translate(
                                            offset: const Offset(
                                                AppDimensions.d8,
                                                AppDimensions.d0),
                                            child: Image.asset(
                                              AppTexts.assetsImage('tickets.png'),
                                              height: AppDimensions.d30,
                                              width: AppDimensions.d20,
                                              color: AppColors.colorWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              navigatorTo(context,
                                  AddReservation(movie: widget.movie));
                            },
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * (1 / 8),
                              height: AppDimensions.d50,
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        (1 / 8),
                                    height: AppDimensions.d50,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorBlueAccent,
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.d5),
                                    ),
                                    child: const Align(
                                      alignment: Alignment(-0.6, 0),
                                      child: Text(
                                        AppTexts.reservation,
                                        style: AppTextStyles.bodyStyle,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      height: AppDimensions.d50,
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  (1 / 8)) /
                                              3,
                                      child: CustomPaint(
                                        painter: CustomShape(),
                                        child: Center(
                                          child: Transform.translate(
                                            offset: const Offset(
                                                AppDimensions.d8,
                                                AppDimensions.d0),
                                            child: Image.asset(
                                              AppTexts.assetsImage('reserv.png'),
                                              height: AppDimensions.d30,
                                              width: AppDimensions.d20,
                                              color: AppColors.colorWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              navigatorTo(
                                  context, EditMovie(movie: widget.movie));
                            },
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * (1 / 8),
                              height: AppDimensions.d50,
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        (1 / 8),
                                    height: AppDimensions.d50,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorBlueAccent,
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.d5),
                                    ),
                                    child: const Align(
                                      alignment:
                                          Alignment(-0.6, AppDimensions.d0),
                                      child: Text(AppTexts.edit,
                                          style: AppTextStyles.bodyStyle),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      height: AppDimensions.d50,
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  (AppDimensions.m1 / 8)) /
                                              3,
                                      child: CustomPaint(
                                        painter: CustomShape(),
                                        child: Center(
                                          child: Transform.translate(
                                            offset: const Offset(
                                                AppDimensions.d8,
                                                AppDimensions.d0),
                                            child: const Icon(
                                              Icons.edit,
                                              size: AppDimensions.d20,
                                              color: AppColors.colorWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async{
                              await navigatorReplace(context, const MyApp());
                              await cub.deleteMovie(movie: widget.movie);
                            },
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * (1 / 8),
                              height: AppDimensions.d50,
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        (1 / 8),
                                    height: AppDimensions.d50,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorBlueAccent,
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.d5),
                                    ),
                                    child: const Align(
                                      alignment:
                                          Alignment(-0.6, AppDimensions.d0),
                                      child: Text(AppTexts.deleteMovie,
                                          style: AppTextStyles.bodyStyle),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      height: AppDimensions.d50,
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  (AppDimensions.m1 / 8)) /
                                              3,
                                      child: CustomPaint(
                                        painter: CustomShape(),
                                        child: Center(
                                          child: Transform.translate(
                                            offset: const Offset(
                                                AppDimensions.d8,
                                                AppDimensions.d0),
                                            child: Image.asset(
                                              AppTexts.assetsImage('delete.png'),
                                              height: AppDimensions.d30,
                                              width: AppDimensions.d20,
                                              color: AppColors.colorWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: AppDimensions.d50),
                      buildTextFormField(
                        label: AppTexts.name,
                        controller: _nameController,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      buildTextFormField(
                        label: AppTexts.date,
                        controller: _dateController,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      buildTextFormField(
                        label: AppTexts.movieHall,
                        controller: _hallController,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      buildTextFormField(
                        label: AppTexts.time,
                        controller: _timeController,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      buildTextFormField(
                        label: AppTexts.reservation,
                        controller: _reservationController,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      buildTextFormField(
                        label: AppTexts.seats,
                        controller: _setsController,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      buildTextFormField(
                        label: AppTexts.availableSeats,
                        controller: _availableSeats,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      buildTextFormField(
                        label: AppTexts.reservedSeats,
                        controller: _reservedSeatsController,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      buildTextFormField(
                        label: AppTexts.price,
                        controller: _priceController,
                      ),
                      const SizedBox(height: AppDimensions.d20),
                      Row(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: AppDimensions.m5,
                                mainAxisSpacing: AppDimensions.d10,
                                crossAxisSpacing: AppDimensions.d10,
                                childAspectRatio: AppDimensions.d1,
                              ),
                              itemBuilder: (context, index) {
                                String chNum = 'A ${index + AppDimensions.m1}';
                                return _chaireBuilder(chNum: chNum);
                              },
                              itemCount:
                                  widget.movie.seats! ~/ AppDimensions.m2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Builder(
                                  builder: (context) {
                                    double itemHeight =
                                        (MediaQuery.of(context).size.width /
                                                25) *
                                            1.0;

                                    int itemCount = 50;
                                    int crossAxisCount = 5;
                                    int rowCount =
                                        (itemCount / crossAxisCount).ceil();

                                    double containerHeight =
                                        rowCount * itemHeight;

                                    return Container(
                                      width: AppDimensions.d1,
                                      height: containerHeight,
                                      color: AppColors.colorGrey,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: AppDimensions.m5,
                                mainAxisSpacing: AppDimensions.d10,
                                crossAxisSpacing: AppDimensions.d10,
                                childAspectRatio: AppDimensions.d1,
                              ),
                              itemBuilder: (context, index) {
                                String chNum = 'B ${index + AppDimensions.m1}';
                                return _chaireBuilder(chNum: chNum);
                              },
                              itemCount: (int.tryParse(_setsController.text)! ~/
                                  AppDimensions.m2),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }, listener: (context, state) {
      if (state is DeleteMovieSuccess) {
        showNotification(context: context, contentType: ContentType.success);
        Navigator.pop(context);
      }
    });
  }

  Widget _chaireBuilder({required String chNum}) {
    bool reserved = widget.movie.reservedSeats!.contains(chNum);
    return CircleAvatar(
      backgroundColor: reserved ? AppColors.colorGreen : AppColors.colorGrey,
      radius: AppDimensions.d5,
      child: Text(chNum),
    );
  }

}
