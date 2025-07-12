part of 'buah_bloc.dart';

sealed class BuahState {}

class BuahInitial extends BuahState {}

class BuahLoading extends BuahState {}

class BuahSuccess extends BuahState {
  final List<BuahResponseModel> listBuah;
  BuahSuccess({required this.listBuah});
}

class BuahSingleSuccess extends BuahState {
  final BuahResponseModel buah;
  BuahSingleSuccess({required this.buah});
}

class BuahFailure extends BuahState {
  final String message;
  BuahFailure({required this.message});
}
