import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/buah_request_model.dart';
import 'package:pamfix/data/model/response/buah_response_model.dart';
import 'package:pamfix/data/repository/buah_repository.dart';

part 'buah_event.dart';
part 'buah_state.dart';

class BuahBloc extends Bloc<BuahEvent, BuahState> {
  final BuahRepository buahRepository;

  BuahBloc({required this.buahRepository}) : super(BuahInitial()) {
    on<GetAllBuahEvent>(_onGetAll);
    on<AddBuahEvent>(_onAdd);
    on<UpdateBuahEvent>(_onUpdate);
    on<DeleteBuahEvent>(_onDelete);
  }

  Future<void> _onGetAll(GetAllBuahEvent event, Emitter<BuahState> emit) async {
    emit(BuahLoading());
    final result = await buahRepository.getAllBuah();
    result.fold(
      (fail) => emit(BuahFailure(message: fail)),
      (data) => emit(BuahSuccess(listBuah: data)),
    );
  }

  Future<void> _onAdd(AddBuahEvent event, Emitter<BuahState> emit) async {
    emit(BuahLoading());
    final result = await buahRepository.addBuah(event.buah);
    result.fold(
      (fail) => emit(BuahFailure(message: fail)),
      (_) => add(GetAllBuahEvent()),
    );
  }

  Future<void> _onUpdate(UpdateBuahEvent event, Emitter<BuahState> emit) async {
    emit(BuahLoading());
    final result = await buahRepository.updateBuah(event.id, event.buah);
    result.fold(
      (fail) => emit(BuahFailure(message: fail)),
      (_) => add(GetAllBuahEvent()),
    );
  }

  Future<void> _onDelete(DeleteBuahEvent event, Emitter<BuahState> emit) async {
    emit(BuahLoading());
    final result = await buahRepository.deleteBuah(event.id);
    result.fold(
      (fail) => emit(BuahFailure(message: fail)),
      (_) => add(GetAllBuahEvent()),
    );
  }
}
