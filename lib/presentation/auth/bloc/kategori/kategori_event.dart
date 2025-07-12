part of 'kategori_bloc.dart';

sealed class KategoriEvent {}

class GetAllKategoriEvent extends KategoriEvent {}

class AddKategoriEvent extends KategoriEvent {
  final KategoriRequestModel kategori;

  AddKategoriEvent({required this.kategori});
}

class UpdateKategoriEvent extends KategoriEvent {
  final int id;
  final KategoriRequestModel kategori;

  UpdateKategoriEvent({required this.id, required this.kategori});
}

class DeleteKategoriEvent extends KategoriEvent {
  final int id;

  DeleteKategoriEvent({required this.id});
}
