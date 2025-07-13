import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/supplier_request_model.dart';
import 'package:pamfix/data/model/response/supplier_response_model.dart';
import 'package:pamfix/data/repository/supplier_repository.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final SupplierRepository supplierRepository;

  SupplierBloc({required this.supplierRepository}) : super(SupplierInitial()) {
    on<GetAllSupplierEvent>(_onGetAll);
    on<AddSupplierEvent>(_onAdd);
    on<UpdateSupplierEvent>(_onUpdate);
    on<DeleteSupplierEvent>(_onDelete);
  }

  Future<void> _onGetAll(GetAllSupplierEvent event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    final result = await supplierRepository.getAllSupplier();
    result.fold(
      (fail) => emit(SupplierFailure(message: fail)),
      (data) => emit(SupplierSuccess(listSupplier: data)),
    );
  }

  Future<void> _onAdd(AddSupplierEvent event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    final result = await supplierRepository.addSupplier(event.supplier);
    result.fold(
      (fail) => emit(SupplierFailure(message: fail)),
      (_) => add(GetAllSupplierEvent()),
    );
  }

  Future<void> _onUpdate(UpdateSupplierEvent event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    final result = await supplierRepository.updateSupplier(event.id, event.supplier);
    result.fold(
      (fail) => emit(SupplierFailure(message: fail)),
      (_) => add(GetAllSupplierEvent()),
    );
  }

  Future<void> _onDelete(DeleteSupplierEvent event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    final result = await supplierRepository.deleteSupplier(event.id);
    result.fold(
      (fail) => emit(SupplierFailure(message: fail)),
      (_) => add(GetAllSupplierEvent()),
    );
  }
}
        