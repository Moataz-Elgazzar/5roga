class AddPlaceState {}

class AddPlaceInitial extends AddPlaceState {}


class AddPlaceLoading extends AddPlaceState {}

class AddPlaceSuccess extends AddPlaceState {}

class AddPlaceError extends AddPlaceState {
  final String error;

  AddPlaceError(this.error);
}