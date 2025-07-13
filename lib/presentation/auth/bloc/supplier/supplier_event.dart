part of 'supplier_bloc.dart';

sealed class SupplierEvent {}

class GetAllSupplierEvent extends SupplierEvent {}

class AddSupplierEvent extends SupplierEvent {
  final SupplierRequestModel supplier;

  AddSupplierEvent({required this.supplier});
}

class UpdateSupplierEvent extends SupplierEvent {
  final int id;
  final SupplierRequestModel supplier;

  UpdateSupplierEvent({required this.id, required this.supplier});
}

class DeleteSupplierEvent extends SupplierEvent {
  final int id;

  DeleteSupplierEvent({required this.id});
}
