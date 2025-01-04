
// Ride State Definitions
sealed class RideState {}

class RideInitial extends RideState {}


class LocationLoading extends RideState {}

class LocationLoaded extends RideState {
  final double latitude;
  final double longitude;
  final String address;

  LocationLoaded(
     this.latitude,
     this.longitude,
     this.address,
  );
}

class LocationError extends RideState {
  final String message;

  LocationError(this.message);
}


class SuggestionsLoading extends RideState{}

class SuggestionsLoaded extends RideState {
  final List<String> suggestions;

  SuggestionsLoaded(this.suggestions);
}

class AddressSelected extends RideState {
  final double latitude;
  final double longitude;
  final String address;

  AddressSelected(this.latitude, this.longitude, this.address);
}



class DestinationError extends RideState {
  final String error;

  DestinationError(this.error);
}


class NearbyDriversLoading extends RideState {}

class NearbyDriversLoaded extends RideState {
  final List<Map<String, dynamic>> drivers;

  NearbyDriversLoaded(this.drivers);
}

class NearbyDriversError extends RideState {
  final String message;

  NearbyDriversError(this.message);
}




class RideDistanceCalculated extends RideState {
  final double distance;

  RideDistanceCalculated(this.distance);
}

class RideFareCalculated extends RideState {
  final double fare;

  RideFareCalculated(this.fare);
}


class ValidationSuccess extends RideState {}

class ValidationError extends RideState {
  final String message;

  ValidationError(this.message);
}
class RideRequested extends RideState {
  final String message;

  RideRequested(this.message);
}

class RideRequestError extends RideState {
  final String message;

  RideRequestError(this.message);
}

class RideLoading extends RideState {}




class VehicleSelected extends RideState {
  final String vehicleType;

  VehicleSelected(this.vehicleType);
}

class PaymentSelected extends RideState {
  final String paymentMethod;

  PaymentSelected(this.paymentMethod);
}



class BottomBarVisibilityChanged extends RideState {
  final bool isVisible;

  BottomBarVisibilityChanged({required this.isVisible});
}


