class Guest {
  int? id;
  String? fullName;
  int? age;
  int? reservations;
  int? movieId;
  List<String>? seats;
  String ? totalPayment;


  Guest(
      {this.id,
        this.fullName,
        this.age,
        this.movieId,
        this.reservations,
        this.totalPayment,
        this.seats});

  Guest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    totalPayment = json['total_payment'];
    age = json['age'];
    movieId = json['movieId'];
    reservations = json['reservations'];
    seats = json['seats'] != null ? List<String>.from(json['seats']) : [];
  }



}
