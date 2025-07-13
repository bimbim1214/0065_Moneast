part of 'pembelian_bloc.dart';

sealed class PembelianState {}

class PembelianInitial extends PembelianState {}

class PembelianLoading extends PembelianState {}

class PembelianSuccess extends PembelianState {
  final List<PembelianResponseModel> listPembelian;
  PembelianSuccess(this.listPembelian);
}

class PembelianFailure extends PembelianState {
  final String message;
  PembelianFailure(this.message);
}
