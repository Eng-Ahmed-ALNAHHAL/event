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
  final TextEditingController _ticketPrice = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
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
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              AppDimensions.d025,
                          height: MediaQuery.of(context).size.height *
                              AppDimensions.d025,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppDimensions.d5),
                              child: cub.newMovieImageUrl == null
                                  ? Image.asset(AppTexts.assetsImage('cool.gif'))
                                  : cub.isUploading
                                      ? Image.asset(AppTexts.assetsImage('tenor.gif'))
                                      : Image.network(cub.newMovieImageUrl!)),
                        ),
                        const SizedBox(height: AppDimensions.d25),
                        MaterialButton(
                          onPressed: (){cub.pickNewImage();}
                          ,child: Container(
                          width: MediaQuery.of(context).size.width *
                            AppDimensions.d025,
                          height: AppDimensions.d50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: AppColors.primaryColor2),
                          child: const Center(child: Text(AppTexts.uploadImage , style: AppTextStyles.bodyStyle,)),
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
                                text: '${_nameController.text}\n',
                                style:
                                    AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.movieHall.padRight(AppDimensions.m20)} : ',
                                style:
                                    AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${_hallController.text}\n',
                                style:
                                    AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.allSeats.padRight(AppDimensions.m20)} : ',
                                style:
                                    AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${_setsController.text}\n',
                                style:
                                    AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.availableSeats.padRight(AppDimensions.m20)} : ',
                                style:
                                    AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${_setsController.text}\n',
                                style:
                                    AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.date.padRight(AppDimensions.m20)} : ',
                                style:
                                    AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${_dateController.text}\n',
                                style:
                                    AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.time.padRight(AppDimensions.m20)} : ',
                                style:
                                    AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${_timeController.text}\n',
                                style:
                                    AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.ticketPrice.padRight(AppDimensions.m20)} : ',
                                style:
                                    AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${_ticketPrice.text}\n',
                                style:
                                    AppTextStyles.labelStyle, // النمط الثاني
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: AppDimensions.d100,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimensions.d15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    double? ticketPrice =
                                        cub.parseDouble(_ticketPrice.text);

                                    if (ticketPrice != null) {
                                      cub
                                          .addMovie(
                                        photo: cub.newMovieImageUrl!,
                                        name: _nameController.text,
                                        date: _dateController.text,
                                        time: _timeController.text,
                                        hall: _hallController.text,
                                        seats: int.parse(_setsController.text),
                                        ticketPrice: ticketPrice,

                                      )
                                          .then((value) {
                                        navigatorReplace(
                                            context, const MyApp());
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
                                    width: MediaQuery.of(context).size.width *
                                        AppDimensions.d20,
                                    height: AppDimensions.d50,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              AppDimensions.d20,
                                          height: AppDimensions.d50,
                                          decoration: BoxDecoration(
                                            color: AppColors.colorBlueAccent,
                                            borderRadius: BorderRadius.circular(
                                                AppDimensions.d5),
                                          ),
                                          child: const Align(
                                            alignment: Alignment(-0.6, 0),
                                            child: Text(AppTexts.addMovie,
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
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
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
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
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
                                label: AppTexts.price,
                                controller: _ticketPrice,
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
        listener: (context, state) {});
  }


}
