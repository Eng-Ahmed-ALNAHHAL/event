import 'guest.dart';
import 'movie.dart';

class Reservation {

  Movie ? movie;
  Guest ? guest;
  String ? reservationsCode;
  int ? reservationId ;

  Reservation({required this.movie,required this.guest,required this.reservationsCode , required this.reservationId});

  Reservation.fromJson(Map<String, dynamic> json) {
    movie = (json['movie'] != null ?  Movie.fromJson(json['movie']) : null)!;
    guest = (json['guest'] != null ?  Guest.fromJson(json['guest']) : null)!;
    reservationsCode = json['reservations_code'];
    reservationId = json['id'];

  }


}

