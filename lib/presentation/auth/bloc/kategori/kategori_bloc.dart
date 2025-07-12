import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/kategori_request_model.dart';
import 'package:pamfix/data/model/response/kategori_response_model.dart';
import 'package:pamfix/data/repository/kategori_buah_repository.dart';

part 'kategori_event.dart';
part 'kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository kategoriRepository;

  KategoriBloc({required this.kategoriRepository}) : super(KategoriInitial()) {
    on<GetAllKategoriEvent>(_onGetAllKategori);
    on<AddKategoriEvent>(_onAddKategori);
    on<UpdateKategoriEvent>(_onUpdateKategori);
    on<DeleteKategoriEvent>(_onDeleteKategori);
  }

  Future<void> _onGetAllKategori(
      GetAllKategoriEvent event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    final result = await kategoriRepository.getAllKategori();
    result.fold(
      (fail) => emit(KategoriFailure(message: fail)),
      (data) => emit(KategoriSuccess(listKategori: data)),
    );
  }

  Future<void> _onAddKategori(
      AddKategoriEvent event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    final result = await kategoriRepository.addKategori(event.kategori);
    result.fold(
      (fail) => emit(KategoriFailure(message: fail)),
      (_) => add(GetAllKategoriEvent()),
    );
  }

  Future<void> _onUpdateKategori(
      UpdateKategoriEvent event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    final result =
        await kategoriRepository.updateKategori(event.id, event.kategori);
    result.fold(
      (fail) => emit(KategoriFailure(message: fail)),
      (_) => add(GetAllKategoriEvent()),
    );
  }

  Future<void> _onDeleteKategori(
      DeleteKategoriEvent event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    final result = await kategoriRepository.deleteKategori(event.id);
    result.fold(
      (fail) => emit(KategoriFailure(message: fail)),
      (_) => add(GetAllKategoriEvent()),
    );
  }
}
