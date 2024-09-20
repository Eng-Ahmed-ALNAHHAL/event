abstract class  AppState {}
class InitCubit extends AppState {}
class ToggleLightAndDark extends AppState {}
class SearchMovieSuccess extends AppState {}
class SearchMovieError extends AppState {
  String error ;
  SearchMovieError({required this.error});
}
class EditMovieSuccess extends AppState {}
class EditMovieError extends AppState {
  String error ;
  EditMovieError({required this.error});
}
class UpdateReservationSuccess extends AppState {}
class UpdateReservationError extends AppState {
  String error ;
  UpdateReservationError({required this.error});
}
class EmpExpanded extends AppState {}
class FirebaseLogOut extends AppState {}
class IsSearching extends AppState {}
class EditingGuest extends AppState {}
class CornerExpanded extends AppState {}
class GetGuests extends AppState {}
class FilterReservationsByMovie extends AppState {}
class GetMovies extends AppState {}
class GetMovieImageUrlSuccess extends AppState {}
class GetMovieImageUrlFailed extends AppState {}
class UploadingMovieImage extends AppState {}
class UploadedSuccess extends AppState {}
class AddMovieSuccess extends AppState {}
class AddMovieError extends AppState {}
class DeleteMovieSuccess extends AppState {}
class PickingNewImage extends AppState {}
class PickNewImageSuccess extends AppState {}
class DeleteMovieError extends AppState {}
class GetReservations extends AppState {}
class ReservedSuccess extends AppState {}
class ReservedError extends AppState {String ?  error ; ReservedError(this.error);}
