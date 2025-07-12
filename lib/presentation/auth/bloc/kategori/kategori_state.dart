part of 'kategori_bloc.dart';

sealed class KategoriState {}

class KategoriInitial extends KategoriState {}

class KategoriLoading extends KategoriState {}

class KategoriSuccess extends KategoriState {
  final List<KategoriResponseModel> listKategori;

  KategoriSuccess({required this.listKategori});
}

class KategoriFailure extends KategoriState {
  final String message;

  KategoriFailure({required this.message});
}
