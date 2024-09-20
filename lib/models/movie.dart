class Movie {
  int? id;
  String? name;
  String? date;
  String? time;
  String? hall;
  int? seats;
  int? reservations;
  int? availableSeats;
  String? photo;
  double? ticketPrice; // Update to double
  List<String>? reservedSeats;

  Movie({
    this.id,
    this.name,
    this.availableSeats,
    this.reservedSeats,
    this.date,
    this.time,
    this.hall,
    this.seats,
    this.reservations,
    this.photo,
    this.ticketPrice,
  });

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    reservedSeats = json['reservedSeats'] != null ? List<String>.from(json['reservedSeats']) : [];
    date = json['date'];
    availableSeats = json['available_seats'];
    time = json['time'];
    hall = json['hall'];
    seats = json['seats'];
    reservations = json['reservations'];
    photo = json['photo'];
    // Convert ticket_price to double
    ticketPrice = json['ticket_price'] != null ? double.tryParse(json['ticket_price'].toString()) ?? 0.0 : null;
  }
}
