part of 'penjualan_bloc.dart';

abstract class PenjualanState {}

class PenjualanInitial extends PenjualanState {}

class PenjualanLoading extends PenjualanState {}

class PenjualanSuccess extends PenjualanState {
  final List<PenjualanResponseModel> penjualanList;
  PenjualanSuccess(this.penjualanList);
}

class PenjualanSingleSuccess extends PenjualanState {
  final PenjualanResponseModel penjualan;
  PenjualanSingleSuccess(this.penjualan);
}

class PenjualanFailure extends PenjualanState {
  final String error;
  PenjualanFailure(this.error);
}

class PenjualanTotalCalculated extends PenjualanState {
  final int total;
  PenjualanTotalCalculated(this.total);
}

