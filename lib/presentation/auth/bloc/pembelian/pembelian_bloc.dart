import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/pembelian_request_model.dart';
import 'package:pamfix/data/model/response/pembelian_response_model.dart';
import 'package:pamfix/data/repository/pembelian_repository.dart';

part 'pembelian_event.dart';
part 'pembelian_state.dart';

class PembelianBloc extends Bloc<PembelianEvent, PembelianState> {
  final PembelianRepository pembelianRepository;

  PembelianBloc({required this.pembelianRepository}) : super(PembelianInitial()) {
    on<GetAllPembelianEvent>(_onGetAll);
    on<AddPembelianEvent>(_onAdd);
    on<UpdatePembelianEvent>(_onUpdate);
    on<DeletePembelianEvent>(_onDelete);
  }

  Future<void> _onGetAll(GetAllPembelianEvent event, Emitter emit) async {
    emit(PembelianLoading());
    final result = await pembelianRepository.getAllPembelian();
    result.fold(
      (l) => emit(PembelianFailure(l)),
      (r) => emit(PembelianSuccess(r)),
    );
  }

  Future<void> _onAdd(AddPembelianEvent event, Emitter emit) async {
    emit(PembelianLoading());
    final result = await pembelianRepository.addPembelian(event.pembelian);
    result.fold(
      (l) => emit(PembelianFailure(l)),
      (_) => add(GetAllPembelianEvent()),
    );
  }

  Future<void> _onUpdate(UpdatePembelianEvent event, Emitter emit) async {
    emit(PembelianLoading());
    final result = await pembelianRepository.updatePembelian(event.id, event.pembelian);
    result.fold(
      (l) => emit(PembelianFailure(l)),
      (_) => add(GetAllPembelianEvent()),
    );
  }

  Future<void> _onDelete(DeletePembelianEvent event, Emitter emit) async {
    emit(PembelianLoading());
    final result = await pembelianRepository.deletePembelian(event.id);
    result.fold(
      (l) => emit(PembelianFailure(l)),
      (_) => add(GetAllPembelianEvent()),
    );
  }
}
