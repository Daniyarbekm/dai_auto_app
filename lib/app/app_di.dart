import 'package:dai_auto_app/api/api_service.dart';
import 'package:dai_auto_app/data/car_repository.dart';
import 'package:dai_auto_app/data/booking_repository.dart';

class AppDI {
  // завтра тут будет ApiService(baseUrl, tokenStorage)
  static final api = ApiService();

  // переключатель (сейчас мок, завтра api)
  static const bool useMock = false;

  static CarRepository get carRepo => useMock ? MockCarRepository() : ApiCarRepository(api);

  static final bookingRepo = BookingRepository(api);
}