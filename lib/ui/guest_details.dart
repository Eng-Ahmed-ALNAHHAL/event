import 'package:cinema/main.dart';
import 'package:cinema/models/ticket.dart';
import 'package:cinema/state_management/cubit.dart';
import 'package:cinema/state_management/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/constants.dart';

class GuestDetails extends StatefulWidget {
  final Reservation reservation;

  const GuestDetails({super.key, required this.reservation});

  @override
  State<GuestDetails> createState() => _GuestDetailsState();
}

class _GuestDetailsState extends State<GuestDetails> {
  late TextEditingController _fullNameController;

  late TextEditingController _ageController;

  late TextEditingController _reservationsController;

  late TextEditingController _totalPaymentController;
  late TextEditingController _reservedSeats;
  late List<String> selectedSeats;

  final List<String> seats = [];

  int maxSeats = 1;

  @override
  void initState() {
    super.initState();

    _fullNameController =
        TextEditingController(text: widget.reservation.guest!.fullName);
    _ageController =
        TextEditingController(text: '${widget.reservation.guest!.age}');
    _reservationsController = TextEditingController(
        text: '${widget.reservation.guest!.reservations}');
    _totalPaymentController = TextEditingController(
        text: '${widget.reservation.guest!.totalPayment}');
    _reservedSeats = TextEditingController(
        text: widget.reservation.guest!.seats?.map((seat) => seat.trim()).join(', '));
    seats.addAll(widget.reservation.guest!.seats!);
    selectedSeats = seats
        .map((seat) => seat)
        .toList(); // تحويل المقاعد إلى lowercase مع الإزالة الجانبية لأي فراغات
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _reservedSeats.dispose();
    _ageController.dispose();
    _reservationsController.dispose();
    _totalPaymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);
    return BlocConsumer<CubitClass, AppState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  if (cub.isEditingGuest) {
                    cub.editingGuest();
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppDimensions.d20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            AppDimensions.d025,
                        height: MediaQuery.of(context).size.height *
                            AppDimensions.d025,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppDimensions.d5)),
                          child: Image.network(
                            widget.reservation.movie!.photo!,
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
                              style: AppTextStyles.labelStyleOrange,
                            ),
                            TextSpan(
                              text: '${widget.reservation.movie!.name}\n',
                              style: AppTextStyles.labelStyle,
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.movieHall.padRight(AppDimensions.m20)} : ',
                              style: AppTextStyles.labelStyleOrange,
                            ),
                            TextSpan(
                              text: '${widget.reservation.movie!.hall}\n',
                              style: AppTextStyles.labelStyle,
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.allSeats.padRight(AppDimensions.m20)} : ',
                              style: AppTextStyles.labelStyleOrange,
                            ),
                            TextSpan(
                              text: '${widget.reservation.movie!.seats}\n',
                              style: AppTextStyles.labelStyle,
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.availableSeats.padRight(AppDimensions.m20)} : ',
                              style: AppTextStyles.labelStyleOrange,
                            ),
                            TextSpan(
                              text:
                                  '${widget.reservation.movie!.availableSeats}\n',
                              style: AppTextStyles.labelStyle,
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.date.padRight(AppDimensions.m20)} : ',
                              style: AppTextStyles.labelStyleOrange,
                            ),
                            TextSpan(
                              text: '${widget.reservation.movie!.date}\n',
                              style: AppTextStyles.labelStyle,
                            ),
                            TextSpan(
                              text:
                                  '${AppTexts.time.padRight(AppDimensions.m20)} : ',
                              style: AppTextStyles.labelStyleOrange,
                            ),
                            TextSpan(
                              text: '${widget.reservation.movie!.time}\n',
                              style: AppTextStyles.labelStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: AppDimensions.d25,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  print(widget.reservation.reservationId);

                                  if (cub.isEditingGuest) {
                                    await cub
                                        .updateReservation(
                                            fullName: _fullNameController.text,
                                            reservations: int.parse(
                                                _reservationsController.text),
                                            seats: selectedSeats,
                                            movieId:
                                                widget.reservation.movie!.id!, age: int.parse(_ageController.text), reservation: widget.reservation)
                                        .then((value) async {
                                      cub.editingGuest();
                                      await navigatorToFirstPage(context,const MyApp() );
                                    });
                                  } else {
                                    cub.editingGuest();
                                  }
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      (1 / 8),
                                  height: AppDimensions.d50,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (1 / 8),
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
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (1 / 8)) /
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
                                                    color: AppColors.colorWhite,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              cub.isEditingGuest
                                  ? const SizedBox()
                                  : MaterialButton(
                                      onPressed: () async {
                                        await cub.generateAndPrintPDF(
                                            name: widget
                                                .reservation.guest!.fullName!,
                                            totalPayment: widget
                                                .reservation.guest!.totalPayment
                                                .toString(),
                                            ticketPrice: widget
                                                .reservation.movie!.ticketPrice
                                                .toString(),
                                            seats: widget
                                                .reservation.guest!.seats!,
                                            movieTitle:
                                                widget.reservation.movie!.name!,
                                            hall:
                                                widget.reservation.movie!.hall!,
                                            reservationCode: widget
                                                .reservation.reservationsCode!);
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (1 / 8),
                                        height: AppDimensions.d50,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (1 / 8),
                                              height: AppDimensions.d50,
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.colorBlueAccent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimensions.d5),
                                              ),
                                              child: const Align(
                                                alignment: Alignment(-0.6, 0),
                                                child: Text(AppTexts.print,
                                                    style: AppTextStyles
                                                        .bodyStyle),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: SizedBox(
                                                height: AppDimensions.d50,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width *
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
                                                            AppTexts.assetsImage(
                                                                'print.png'),
                                                            color: AppColors
                                                                .colorWhite)),
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
                          const SizedBox(
                            height: AppDimensions.d30,
                          ),
                          cub.isEditingGuest?SizedBox(width: MediaQuery.of(context).size.width,height: AppDimensions.d5 , child: LinearProgressIndicator(color: Colors.pink.shade400,)):const SizedBox(),

                          const SizedBox(
                            height: AppDimensions.d30,
                          ),

                          buildTextFormField(
                              label: AppTexts.name,
                              readOnly: cub.isEditingGuest ? false : true,
                              controller: _fullNameController),
                          const SizedBox(
                            height: AppDimensions.d10,
                          ),
                          buildTextFormField(
                              readOnly: cub.isEditingGuest ? false : true,
                              label: AppTexts.age,
                              controller: _ageController),
                          const SizedBox(
                            height: AppDimensions.d10,
                          ),
                          buildTextFormField(
                              readOnly: cub.isEditingGuest ? false : true,
                              label: AppTexts.reservation,
                              controller: _reservationsController,
                              onChanged: (value) {
                                setState(() {

                                  maxSeats = int.tryParse(value) ?? 1;
                                  int reservations = int.tryParse(value) ?? 1;
                                  _totalPaymentController.text =
                                      (widget.reservation.movie!.ticketPrice! *
                                              reservations)
                                          .toString();
                                });
                              }),
                          const SizedBox(
                            height: AppDimensions.d10,
                          ),
                          buildTextFormField(
                              readOnly: cub.isEditingGuest ? false : true,
                              label: AppTexts.totalPayment,
                              controller: _totalPaymentController),
                          const SizedBox(
                            height: AppDimensions.d20,
                          ),
                          buildTextFormField(
                              readOnly: cub.isEditingGuest ? false : true,
                              label: AppTexts.reservedSeats,
                              controller: _reservedSeats,),

                          const SizedBox(
                            height: AppDimensions.d20,
                          ),
                          const Text(
                            AppTexts.seats,
                            style: AppTextStyles.bodyStyle,
                          ),
                          const SizedBox(
                            height: AppDimensions.d20,
                          ),
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
                                    return _chairBuilder(
                                        chNum: chNum,
                                        isEditMode: cub.isEditingGuest);
                                  },
                                  itemCount:
                                      widget.reservation.movie!.seats! ~/ 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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
                                            (MediaQuery.of(context).size.width /
                                                    25) *
                                                1.0;

                                        int itemCount =
                                            widget.reservation.movie!.seats! ~/
                                                2;
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
                                    String chNum = 'B ${index + 1}';
                                    return _chairBuilder(
                                        chNum: chNum,
                                        isEditMode: cub.isEditingGuest);
                                  },
                                  itemCount:
                                      widget.reservation.movie!.seats! ~/ 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }

  Widget _chairBuilder({required String chNum, required bool isEditMode}) {
    List<String> reservedSeats = widget.reservation.movie!.reservedSeats!;

    // تحقق إذا كان المقعد محجوزًا من قبل الضيف
    bool isGuestSeat = widget.reservation.guest!.seats!.contains(chNum);

    // تحقق إذا كان المقعد محجوزًا من شخص آخر
    bool isReserved = reservedSeats.contains(chNum) && !isGuestSeat;

    // تحقق إذا كان المقعد مختارًا حاليًا
    bool isSelected = selectedSeats.contains(chNum);

    // إذا كنا في وضع التحرير
    if (isEditMode) {
      return GestureDetector(
        onTap: isReserved
            ? null // إذا كان محجوزًا من شخص آخر، لا يمكن الضغط عليه
            : () {
          setState(() {
            // إذا كان المقعد مختارًا، قم بإزالته
            if (isSelected) {
              selectedSeats.remove(chNum);
              _reservedSeats.clear();
              print('Removed $chNum from selectedSeats');
            } else {
              // إذا لم يصل الحد الأقصى، أضف المقعد
              if (selectedSeats.length < maxSeats) {
                selectedSeats.add(chNum);
                _reservedSeats.text = selectedSeats.map((seat) => seat.trim()).join(', ');

              }
            }
          });
        },
        child: CircleAvatar(
          // تحديد اللون بناءً على الحالة الحالية
          backgroundColor: (selectedSeats.contains(chNum) || isGuestSeat)
              ? AppColors.colorGreen // مختار أو مقعد الضيف
              : (isReserved ? AppColors.colorRed : AppColors.colorGrey), // محجوز من شخص آخر أو فارغ
          radius: AppDimensions.d30 / 2,
          child: Text(chNum),
        ),
      );
    } else {
      // في حالة العرض فقط (بدون تحرير)
      return CircleAvatar(
        backgroundColor: isGuestSeat
            ? AppColors.colorGreen // مقعد الضيف
            : isReserved
            ? AppColors.colorRed // محجوز من شخص آخر
            : AppColors.colorGrey, // غير محجوز
        radius: AppDimensions.d30 / 2,
        child: Text(chNum),
      );
    }
  }
}
