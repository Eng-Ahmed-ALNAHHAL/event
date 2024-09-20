import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/constants.dart';
import '../models/movie.dart';
import '../state_management/cubit.dart';
import '../state_management/states.dart';
import 'guest_details.dart';

class Reservations extends StatefulWidget {
  final Movie movie;

  const Reservations({super.key, required this.movie});

  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CubitClass.get(context).filterReservationsByMovie(widget.movie.id!);
  }

  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(context);

    return BlocBuilder<CubitClass, AppState>(builder: (context, state) {
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
          padding: EdgeInsets.all(AppDimensions.d15.toDouble()),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    width:
                        MediaQuery.of(context).size.width * AppDimensions.d025,
                    height:
                        MediaQuery.of(context).size.height * AppDimensions.d025,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppDimensions.d5)),
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
                          style: AppTextStyles.labelStyleOrange,
                        ),
                        TextSpan(
                          text: '${widget.movie.name}\n',
                          style: AppTextStyles.labelStyle,
                        ),
                        TextSpan(
                          text:
                              '${AppTexts.movieHall.padRight(AppDimensions.m20)} : ',
                          style: AppTextStyles.labelStyleOrange,
                        ),
                        TextSpan(
                          text: '${widget.movie.hall}\n',
                          style: AppTextStyles.labelStyle,
                        ),
                        TextSpan(
                          text:
                              '${AppTexts.allSeats.padRight(AppDimensions.m20)} : ',
                          style: AppTextStyles.labelStyleOrange,
                        ),
                        TextSpan(
                          text: '${widget.movie.seats}\n',
                          style: AppTextStyles.labelStyle,
                        ),
                        TextSpan(
                          text:
                              '${AppTexts.availableSeats.padRight(AppDimensions.m20)} : ',
                          style: AppTextStyles.labelStyleOrange,
                        ),
                        TextSpan(
                          text: '${widget.movie.availableSeats}\n',
                          style: AppTextStyles.labelStyle,
                        ),
                        TextSpan(
                          text:
                              '${AppTexts.date.padRight(AppDimensions.m20)} : ',
                          style: AppTextStyles.labelStyleOrange,
                        ),
                        TextSpan(
                          text: '${widget.movie.date}\n',
                          style: AppTextStyles.labelStyle,
                        ),
                        TextSpan(
                          text:
                              '${AppTexts.time.padRight(AppDimensions.m20)} : ',
                          style: AppTextStyles.labelStyleOrange,
                        ),
                        TextSpan(
                          text: '${widget.movie.time}\n',
                          style: AppTextStyles.labelStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: AppDimensions.d20,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${AppTexts.reservations} ${cub.filteredReservations.length}',
                          style: AppTextStyles.titlesStyle,
                        ),
                        !cub.isSearchReservation
                            ? IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  cub.reservationSearch();
                                },
                              )
                            : Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        AppDimensions.d025,
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: AppTexts.searchHint,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimensions.m15.toDouble()),
                                        ),
                                      ),
                                      onChanged: (query) {
                                        cub.searchMovies(word: query);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      cub.reservationSearch();
                                      _searchController.clear();
                                    },
                                  ),
                                ],
                              ),
                      ],
                    ),
                    const Divider(
                      thickness: AppDimensions.d1,
                    ),
                    const SizedBox(height: AppDimensions.d10),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                      },
                      border: const TableBorder.symmetric(
                        inside: BorderSide(color: Colors.transparent),
                      ),
                      children: [
                        const TableRow(
                          children: [
                            Text(AppTexts.name,
                                style: AppTextStyles.labelStyle),
                            Text(AppTexts.totalPayment,
                                style: AppTextStyles.labelStyle),
                            Text(AppTexts.reservationCode,
                                style: AppTextStyles.labelStyle),
                          ],
                        ),
                        for (var reservation in cub.filteredReservations)
                          TableRow(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  navigatorTo(context,
                                      GuestDetails(reservation: reservation));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(reservation.guest!.fullName!,
                                      style: AppTextStyles.descStyle),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    reservation.guest!.totalPayment!.toString(),
                                    style: AppTextStyles.descStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(reservation.reservationsCode!,
                                    style: AppTextStyles.descStyle),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
