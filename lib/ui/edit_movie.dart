import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../components/constants.dart';
import '../models/movie.dart';
import '../state_management/cubit.dart';
import '../state_management/states.dart';
import 'main_page.dart';

class EditMovie extends StatefulWidget {
  final Movie movie;

  const EditMovie({super.key, required this.movie});

  @override
  State<EditMovie> createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _hallController;
  late TextEditingController _timeController;
  late TextEditingController _setsController;
  late TextEditingController _priceController;
  late TextEditingController _availableSeats;
  String hallLetter = 'h';
  String hallNum = '1';

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController(text: widget.movie.name);
    _dateController = TextEditingController(text: widget.movie.date ?? '');
    _hallController = TextEditingController(text: '$hallLetter $hallNum');
    _timeController = TextEditingController(text: widget.movie.time ?? '');
    _setsController =
        TextEditingController(text: widget.movie.seats?.toString() ?? '');
    _availableSeats = TextEditingController(
        text: widget.movie.availableSeats?.toString() ?? '');
    _priceController =
        TextEditingController(text: widget.movie.ticketPrice?.toString() ?? '');
    var formKey = GlobalKey<FormState>();

    CubitClass cub = CubitClass.get(context);

    return BlocConsumer<CubitClass, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppDimensions.d10),
            child: Form(
              key: formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppDimensions.d5)),
                          child: cub.isUploading
                              ? const LoadingIndicator(
                                  indicatorType: Indicator.ballScaleMultiple)
                              : Stack(
                                  children: [
                                    Image.network(
                                      cub.movieImageUrl == '' ||
                                              cub.movieImageUrl == null
                                          ? widget.movie.photo!
                                          : cub.movieImageUrl!,
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        cub.imagePicker(movie: widget.movie);
                                      },
                                      child: const Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          radius: AppDimensions.d20,
                                          backgroundColor: AppColors.colorGrey,
                                          child: Icon(Icons.edit),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.d25),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${AppTexts.movieTitle.padRight(AppDimensions.m20)} : ',
                              style:
                                  AppTextStyles.labelStyleOrange, // النمط الأول
                            ),
                            TextSpan(
                              text: '${widget.movie.name}\n',
                              style: AppTextStyles.labelStyle, // النمط الثاني
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.movieHall.padRight(AppDimensions.m20)} : ',
                              style:
                                  AppTextStyles.labelStyleOrange, // النمط الأول
                            ),
                            TextSpan(
                              text: '${widget.movie.hall}\n',
                              style: AppTextStyles.labelStyle, // النمط الثاني
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.allSeats.padRight(AppDimensions.m20)} : ',
                              style:
                                  AppTextStyles.labelStyleOrange, // النمط الأول
                            ),
                            TextSpan(
                              text: '${widget.movie.seats}\n',
                              style: AppTextStyles.labelStyle, // النمط الثاني
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.availableSeats.padRight(AppDimensions.m20)} : ',
                              style:
                                  AppTextStyles.labelStyleOrange, // النمط الأول
                            ),
                            TextSpan(
                              text: '${widget.movie.reservations}\n',
                              style: AppTextStyles.labelStyle, // النمط الثاني
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.date.padRight(AppDimensions.m20)} : ',
                              style:
                                  AppTextStyles.labelStyleOrange, // النمط الأول
                            ),
                            TextSpan(
                              text: '${widget.movie.date}\n',
                              style: AppTextStyles.labelStyle, // النمط الثاني
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.time.padRight(AppDimensions.m20)} : ',
                              style:
                                  AppTextStyles.labelStyleOrange, // النمط الأول
                            ),
                            TextSpan(
                              text: '${widget.movie.time}\n',
                              style: AppTextStyles.labelStyle, // النمط الثاني
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppDimensions.d50),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.d15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate() &&
                                    (int.tryParse(_setsController.text) ?? 0) %
                                            2 ==
                                        0) {
                                  cub.editMovie(
                                    name: _nameController.text,
                                    date: _dateController.text,
                                    hall: _hallController.text,
                                    time: _timeController.text,
                                    seats: int.parse(_setsController.text),
                                    availableSeats:
                                        int.parse(_availableSeats.text),
                                    ticketPrice:
                                        double.parse(_priceController.text),
                                    photo: cub.movieImageUrl == null ||
                                            cub.movieImageUrl == ''
                                        ? widget.movie.photo!
                                        : cub.movieImageUrl!,
                                    movie: widget.movie,
                                    reservations: widget.movie.reservations!,
                                    reservedSeats: widget.movie.reservedSeats!,
                                  );
                                }
                              },
                              child: Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      AppDimensions.d20,
                                  height: AppDimensions.d50,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                AppDimensions.d20,
                                        height: AppDimensions.d50,
                                        decoration: BoxDecoration(
                                          color: AppColors.colorBlueAccent,
                                          borderRadius: BorderRadius.circular(
                                              AppDimensions.d5),
                                        ),
                                        child: const Align(
                                          alignment: Alignment(-0.6, 0),
                                          child: Text(AppTexts.edit,
                                              style: AppTextStyles.bodyStyle),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: SizedBox(
                                          height: AppDimensions.d50,
                                          width: AppDimensions.d100,
                                          child: CustomPaint(
                                            painter: CustomShape(),
                                            child: Center(
                                              child: Transform.translate(
                                                offset: const Offset(
                                                    AppDimensions.d15, 0),
                                                child: Image.asset(
                                                    AppTexts.assetsImage('true_icon.png')),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.d50),
                            buildTextFormField(
                              label: AppTexts.name,
                              controller: _nameController,
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              readOnly: true,
                              label: AppTexts.date,
                              controller: _dateController,
                              suffix: IconButton(
                                onPressed: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: AppColors.colorBlue,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    String date =
                                        '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                                    _dateController.text = date;
                                  }
                                },
                                icon: const Icon(Icons.date_range_outlined),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              label: AppTexts.time,
                              controller: _timeController,
                              suffix: IconButton(
                                onPressed: () async {
                                  final TimeOfDay? pickedTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: AppColors.colorBlue,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    String time =
                                        '${pickedTime.hour}:${pickedTime.minute}';
                                    _timeController.text = time;
                                  }
                                },
                                icon: const Icon(Icons.watch_later_outlined),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              readOnly: true,
                              label: 'Hall',
                              controller: _hallController,
                              suffix: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // DropdownButton for hallLetter
                                  DropdownButton<String>(
                                    dropdownColor: Colors.blueAccent,
                                    value: hallLetter,
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'h',
                                          child: Text('h',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                      DropdownMenuItem(
                                          value: 'z',
                                          child: Text('z',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    ],
                                    onChanged: (item) {
                                      setState(() {
                                        hallLetter = item!;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  // DropdownButton for hallNum
                                  DropdownButton<String>(
                                    dropdownColor: Colors.blueAccent,
                                    value: hallNum,
                                    items: const [
                                      DropdownMenuItem(
                                          value: '1',
                                          child: Text('1',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                      DropdownMenuItem(
                                          value: '2',
                                          child: Text('2',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    ],
                                    onChanged: (item) {
                                      setState(() {
                                        hallNum = item!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              label: AppTexts.seats,
                              controller: _setsController,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              label: AppTexts.availableSeats,
                              controller: _availableSeats,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              label: AppTexts.price,
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is EditMovieSuccess) {
          showNotification(
            context: context,
            contentType: ContentType.success,
            title: AppTexts.edit,
            message: 'Movie was updated successfully!',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        } else if (state is EditMovieError) {
          showNotification(
            context: context,
            contentType: ContentType.failure,
            title: AppTexts.edit,
            message: 'Failed to update the movie.',
          );
        }
      },
    );
  }
}
