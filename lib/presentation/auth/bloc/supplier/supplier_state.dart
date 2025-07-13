part of 'supplier_bloc.dart';

sealed class SupplierState {}

class SupplierInitial extends SupplierState {}

class SupplierLoading extends SupplierState {}

class SupplierSuccess extends SupplierState {
  final List<SupplierResponsesModel> listSupplier;

  SupplierSuccess({required this.listSupplier});
}

class SupplierFailure extends SupplierState {
  final String message;

  SupplierFailure({required this.message});
}
