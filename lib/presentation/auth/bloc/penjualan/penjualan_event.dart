
part of 'penjualan_bloc.dart';

abstract class PenjualanEvent {}

class GetAllPenjualan extends PenjualanEvent {}

class AddPenjualan extends PenjualanEvent {
  final PenjualanRequestModel request;
  AddPenjualan(this.request);
}

class UpdatePenjualan extends PenjualanEvent {
  final int id;
  final PenjualanRequestModel request;
  UpdatePenjualan(this.id, this.request);
}

class DeletePenjualan extends PenjualanEvent {
  final int id;
  DeletePenjualan(this.id);
}

class CalculatePenjualanTotalEvent extends PenjualanEvent {
  final int jumlah;
  final int harga;

  CalculatePenjualanTotalEvent({required this.jumlah, required this.harga});
}
