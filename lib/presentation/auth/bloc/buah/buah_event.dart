part of 'buah_bloc.dart';

sealed class BuahEvent {}

class GetAllBuahEvent extends BuahEvent {}

class AddBuahEvent extends BuahEvent {
  final BuahRequestModel buah;
  AddBuahEvent({required this.buah});
}

class UpdateBuahEvent extends BuahEvent {
  final int id;
  final BuahRequestModel buah;
  UpdateBuahEvent({required this.id, required this.buah});
}

class DeleteBuahEvent extends BuahEvent {
  final int id;
  DeleteBuahEvent({required this.id});
}
