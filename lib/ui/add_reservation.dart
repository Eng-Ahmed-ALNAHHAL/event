import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/constants.dart'; // تأكد من تحديث المسار حسب الحاجة
import '../models/movie.dart';
import '../state_management/cubit.dart';
import '../state_management/states.dart';

class AddReservation extends StatefulWidget {
  final Movie movie;

  const AddReservation({super.key, required this.movie});

  @override
  State<AddReservation> createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController reservationsController =
      TextEditingController(text: '1');
  final TextEditingController seatsController = TextEditingController();

  List<String> selectedSeats = [];
  int maxSeats = 1;

  @override
  void initState() {
    super.initState();
    CubitClass.get(context).filterReservationsByMovie(widget.movie.id!);
  }

  @override
  Widget build(BuildContext context) {
    final cub = CubitClass.get(context);

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
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.d10),
              child: Row(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              AppDimensions.d025,
                          height: MediaQuery.of(context).size.height *
                              AppDimensions.d025,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimensions.d5),
                            child: Image.network(
                              widget.movie.photo!,
                              fit: BoxFit.contain,
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
                                style: AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${widget.movie.name}\n',
                                style: AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.movieHall.padRight(AppDimensions.m20)} : ',
                                style: AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${widget.movie.hall}\n',
                                style: AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.allSeats.padRight(AppDimensions.m20)} : ',
                                style: AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${widget.movie.seats}\n',
                                style: AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.availableSeats.padRight(AppDimensions.m20)} : ',
                                style: AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${widget.movie.reservations}\n',
                                style: AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.date.padRight(AppDimensions.m20)} : ',
                                style: AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${widget.movie.date}\n',
                                style: AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.time.padRight(AppDimensions.m20)} : ',
                                style: AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${widget.movie.time}\n',
                                style: AppTextStyles.labelStyle, // النمط الثاني
                              ),
                              TextSpan(
                                text:
                                    '${AppTexts.ticketPrice.padRight(AppDimensions.m20)} : ',
                                style: AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text: '${widget.movie.ticketPrice} \$ \n',
                                style: AppTextStyles.labelStyle, // النمط الثاني
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: AppDimensions.d50,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${AppTexts.totalPayment.padRight(AppDimensions.m20)} : ',
                                style: AppTextStyles.labelStyleOrange, // النمط الأول
                              ),
                              TextSpan(
                                text:
                                    '${(widget.movie.ticketPrice! * int.parse(reservationsController.text)).toString()} \$\n',
                                style: AppTextStyles.labelStyle, // النمط الثاني
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.d15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                widget.movie.reservedSeats!
                                    .addAll(selectedSeats);
                                await cub.addReservation(
                                  movie: widget.movie,
                                  name: nameController.text,
                                  age: int.parse(ageController.text),
                                  seats: selectedSeats,
                                  reservations:
                                      int.parse(reservationsController.text),
                                );
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
                                          child: Text(AppTexts.reservation,
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
                              controller: nameController,
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              label: AppTexts.age,
                              controller: ageController,
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              label: AppTexts.reservations,
                              controller: reservationsController,
                              onChanged: (value) {
                                setState(() {
                                  maxSeats = int.tryParse(value) ?? 1;
                                  selectedSeats.clear();
                                  seatsController.clear();
                                });
                              },
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            buildTextFormField(
                              label: AppTexts.seats,
                              controller: seatsController,
                              readOnly: true,
                            ),
                            const SizedBox(height: AppDimensions.d20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      String chNum = 'A ${index + 1}';
                                      return _chairBuilder(chNum: chNum);
                                    },
                                    itemCount: AppDimensions.m60,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          double itemHeight =
                                              (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      25) *
                                                  1.0;

                                          int itemCount = 50;
                                          int crossAxisCount = 5;
                                          int rowCount =
                                              (itemCount / crossAxisCount)
                                                  .ceil();

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
                                      String chNum = 'B ${index + 1}';
                                      return _chairBuilder(chNum: chNum);
                                    },
                                    itemCount: AppDimensions.m60,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                ),
                              ],
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
        if (state is ReservedSuccess) {
          showNotification(
            context: context,
            contentType: ContentType.success,
            title: AppTexts.reservation,
            message: 'Reservation added successfully',
          );
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _chairBuilder({required String chNum}) {
    final isSelected = selectedSeats.contains(chNum);
    bool reserved = widget.movie.reservedSeats!.contains(chNum);

    return GestureDetector(
      onTap: reserved
          ? null
          : () {
              // إذا كان محجوزًا، لن يتمكن المستخدم من الضغط عليه
              setState(() {
                if (isSelected) {
                  selectedSeats.remove(chNum);
                } else {
                  if (selectedSeats.length < maxSeats) {
                    selectedSeats.add(chNum);
                  }
                }
                seatsController.text = selectedSeats.join(',');
              });
            },
      child: CircleAvatar(
        backgroundColor: isSelected
            ? AppColors.colorGreen
            : reserved
                ? AppColors.colorRed
                : AppColors.colorGrey,
        radius: AppDimensions.d30 / 2,
        child: Text(chNum),
      ),
    );
  }


}
