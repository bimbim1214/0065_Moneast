part of 'pembelian_bloc.dart';

sealed class PembelianEvent {}

class GetAllPembelianEvent extends PembelianEvent {}

class AddPembelianEvent extends PembelianEvent {
  final PembelianRequestModel pembelian;
  AddPembelianEvent(this.pembelian);
}

class UpdatePembelianEvent extends PembelianEvent {
  final int id;
  final PembelianRequestModel pembelian;
  UpdatePembelianEvent(this.id, this.pembelian);
}

class DeletePembelianEvent extends PembelianEvent {
  final int id;
  DeletePembelianEvent(this.id);
}
