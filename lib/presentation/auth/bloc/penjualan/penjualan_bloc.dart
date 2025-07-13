import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pamfix/data/model/request/admin/penjualan_request_model.dart';
import 'package:pamfix/data/model/response/penjualan_response_model.dart';
import 'package:pamfix/data/repository/penjualan_repository.dart';

part 'penjualan_event.dart';
part 'penjualan_state.dart';

class PenjualanBloc extends Bloc<PenjualanEvent, PenjualanState> {
  final PenjualanRepository penjualanRepository;

  PenjualanBloc({required this.penjualanRepository}) : super(PenjualanInitial()) {
    on<GetAllPenjualan>((event, emit) async {
      emit(PenjualanLoading());
      final result = await penjualanRepository.getAllPenjualan();
      result.fold(
        (error) => emit(PenjualanFailure(error)),
        (data) => emit(PenjualanSuccess(data)),
      );
    });

    on<AddPenjualan>((event, emit) async {
      emit(PenjualanLoading());
      final result = await penjualanRepository.addPenjualan(event.request);
      result.fold(
        (error) => emit(PenjualanFailure(error)),
        (data) => emit(PenjualanSingleSuccess(data)),
      );
    });

    on<UpdatePenjualan>((event, emit) async {
      emit(PenjualanLoading());
      final result = await penjualanRepository.updatePenjualan(event.id, event.request);
      result.fold(
        (error) => emit(PenjualanFailure(error)),
        (data) => emit(PenjualanSingleSuccess(data)),
      );
    });

    on<DeletePenjualan>((event, emit) async {
      emit(PenjualanLoading());
      final result = await penjualanRepository.deletePenjualan(event.id);
      result.fold(
        (error) => emit(PenjualanFailure(error)),
        (_) => add(GetAllPenjualan()), // refresh list
      );
    });

    on<CalculatePenjualanTotalEvent>((event, emit) {
      final total = event.jumlah * event.harga;
      emit(PenjualanTotalCalculated(total));
    });
  }
}
