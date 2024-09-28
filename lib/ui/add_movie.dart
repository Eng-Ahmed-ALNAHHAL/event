import 'package:cinema/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/constants.dart';
import '../state_management/cubit.dart';
import '../state_management/states.dart';

class AddMovie extends StatefulWidget {
  const AddMovie({super.key});

  @override
  State<AddMovie> createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  late TextEditingController _hallController;
  String hallLetter = 'h';
  String hallNum = '1';

  @override
  Widget build(BuildContext context) {
    _hallController = TextEditingController(text: '$hallLetter$hallNum');
    var formKey = GlobalKey<FormState>();
    CubitClass cub = CubitClass.get(context);

    return BlocConsumer<CubitClass, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.d10),
              child: Row(
                children: [
                  _buildMovieImage(cub),
                  const SizedBox(width: AppDimensions.d100),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.d15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAddMovieButton(cub, formKey),
                            const SizedBox(height: AppDimensions.d50),
                            ..._buildTextFields(),
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
      listener: (context, state) {},
    );
  }

  Widget _buildMovieImage(CubitClass cub) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * AppDimensions.d025,
          height: MediaQuery.of(context).size.height * AppDimensions.d025,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.d5),
            child: cub.newMovieImageUrl == null
                ? Image.asset(AppTexts.assetsImage('cool.gif'))
                : cub.isUploading
                ? Image.asset(AppTexts.assetsImage('tenor.gif'))
                : Image.network(cub.newMovieImageUrl!),
          ),
        ),
        const SizedBox(height: AppDimensions.d25),
        MaterialButton(
          onPressed: () => cub.pickNewImage(),
          child: Container(
            width: MediaQuery.of(context).size.width * AppDimensions.d025,
            height: AppDimensions.d50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryColor2,
            ),
            child: const Center(
              child: Text(
                AppTexts.uploadImage,
                style: AppTextStyles.bodyStyle,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.d25),
        _buildMovieDetails(cub),
      ],
    );
  }

  Widget _buildMovieDetails(CubitClass cub) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          _buildDetailText(AppTexts.movieTitle, _nameController.text),
          _buildDetailText(AppTexts.movieHall, _hallController.text),
          _buildDetailText(AppTexts.allSeats, _seatsController.text),
          _buildDetailText(AppTexts.availableSeats, _seatsController.text),
          _buildDetailText(AppTexts.date, _dateController.text),
          _buildDetailText(AppTexts.time, _timeController.text),
          _buildDetailText(AppTexts.ticketPrice, _ticketPriceController.text),
        ],
      ),
    );
  }

  TextSpan _buildDetailText(String label, String value) {
    return TextSpan(
      children: [
        TextSpan(
          text: '${label.padRight(AppDimensions.m20)} : ',
          style: AppTextStyles.labelStyleOrange,
        ),
        TextSpan(
          text: '$value\n',
          style: AppTextStyles.labelStyle,
        ),
      ],
    );
  }

  Widget _buildAddMovieButton(CubitClass cub, GlobalKey<FormState> formKey) {
    return MaterialButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          double? ticketPrice = cub.parseDouble(_ticketPriceController.text);

          if (ticketPrice != null) {
            cub.addMovie(
              photo: cub.newMovieImageUrl!,
              name: _nameController.text,
              date: _dateController.text,
              time: _timeController.text,
              hall: _hallController.text,
              seats: int.parse(_seatsController.text),
              ticketPrice: ticketPrice,
            ).then((value) {
              navigatorReplace(context, const MyApp());
            });
          } else {
            if (kDebugMode) {
              print('Invalid ticket price');
            }
          }
        }
      },
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * AppDimensions.d20,
          height: AppDimensions.d50,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorBlueAccent,
                  borderRadius: BorderRadius.circular(AppDimensions.d5),
                ),
                child: const Align(
                  alignment: Alignment(-0.6, 0),
                  child: Text(AppTexts.addMovie, style: AppTextStyles.bodyStyle),
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
                        offset: const Offset(AppDimensions.d15, 0),
                        child: Image.asset(AppTexts.assetsImage('true_icon.png')),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      buildTextFormField(label: AppTexts.name, controller: _nameController),
      const SizedBox(height: AppDimensions.d20),
      buildTextFormField(
        readOnly: true,
        label: AppTexts.date,
        controller: _dateController,
        suffix: IconButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
              builder: (BuildContext context, Widget? child) {
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
              String date = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
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
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
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
              String time = '${pickedTime.hour}:${pickedTime.minute}';
              _timeController.text = time;
            }
          },
          icon: const Icon(Icons.watch_later_outlined),
        ),
      ),
      const SizedBox(height: AppDimensions.d20),
      _buildHallDropdown(),
      const SizedBox(height: AppDimensions.d20),
      buildTextFormField(
        label: AppTexts.seats,
        controller: _seatsController,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: AppDimensions.d20),
      buildTextFormField(
        label: AppTexts.price,
        controller: _ticketPriceController,
        keyboardType: TextInputType.number,
      ),
    ];
  }

  Widget _buildHallDropdown() {
    return buildTextFormField(
      readOnly: true,
      label: AppTexts.movieHall,
      controller: _hallController,
      suffix: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DropdownButton<String>(
            dropdownColor: AppColors.colorBlueAccent,
            value: hallLetter,
            items: const [
              DropdownMenuItem(value: 'h', child: Text('h')),
              DropdownMenuItem(value: 'd', child: Text('d')),
              DropdownMenuItem(value: 's', child: Text('s')),
            ],
            onChanged: (String? value) {
              setState(() {
                hallLetter = value!;
                _hallController.text = '$hallLetter$hallNum';
              });
            },
          ),
          const SizedBox(width: AppDimensions.d10),
          DropdownButton<String>(
            dropdownColor: AppColors.colorBlueAccent,
            value: hallNum,
            items: const [
              DropdownMenuItem(value: '1', child: Text('1')),
              DropdownMenuItem(value: '2', child: Text('2')),
              DropdownMenuItem(value: '3', child: Text('3')),
            ],
            onChanged: (String? value) {
              setState(() {
                hallNum = value!;
                _hallController.text = '$hallLetter$hallNum';
              });
            },
          ),
        ],
      ),
    );
  }
}
