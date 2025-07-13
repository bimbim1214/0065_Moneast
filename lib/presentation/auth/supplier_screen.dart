import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/supplier_request_model.dart';
import 'package:pamfix/data/model/response/buah_response_model.dart';
import 'package:pamfix/presentation/auth/bloc/supplier/supplier_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/buah/buah_bloc.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  final _jumlahController = TextEditingController();
  int? _selectedBuahId;
  int? _editId;

  @override
  void initState() {
    super.initState();
    context.read<SupplierBloc>().add(GetAllSupplierEvent());
    context.read<BuahBloc>().add(GetAllBuahEvent()); // ambil data buah
  }

  void _submitForm() {
    final model = SupplierRequestModel(
      nama: _namaController.text,
      alamat: _alamatController.text,
      telepon: _teleponController.text,
      jumlah: int.tryParse(_jumlahController.text),
      buahId: _selectedBuahId,
    );

    if (_editId == null) {
      context.read<SupplierBloc>().add(AddSupplierEvent(supplier: model));
    } else {
      context.read<SupplierBloc>().add(UpdateSupplierEvent(id: _editId!, supplier: model));
    }

    _clearForm();
  }

  void _clearForm() {
    _namaController.clear();
    _alamatController.clear();
    _teleponController.clear();
    _jumlahController.clear();
    _selectedBuahId = null;
    setState(() => _editId = null);
  }

  void _fillFormForEdit(supplier) {
    _namaController.text = supplier.nama ?? '';
    _alamatController.text = supplier.alamat ?? '';
    _teleponController.text = supplier.telepon ?? '';
    _jumlahController.text = supplier.jumlah?.toString() ?? '';
    _selectedBuahId = supplier.buahId;
    setState(() => _editId = supplier.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Supplier")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _namaController, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: _alamatController, decoration: const InputDecoration(labelText: "Alamat")),
            TextField(controller: _teleponController, decoration: const InputDecoration(labelText: "Telepon")),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah"),
            ),
            BlocBuilder<BuahBloc, BuahState>(
              builder: (context, state) {
                if (state is BuahSuccess) {
                  return DropdownButtonFormField<int>(
                    value: _selectedBuahId,
                    items: state.listBuah.map((buah) {
                      return DropdownMenuItem<int>(
                        value: buah.id,
                        child: Text(buah.nama ?? '-'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedBuahId = value),
                    decoration: const InputDecoration(labelText: "Pilih Buah"),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_editId == null ? "Tambah" : "Update"),
                ),
                if (_editId != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(onPressed: _clearForm, child: const Text("Batal")),
                ],
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<SupplierBloc, SupplierState>(
                builder: (context, state) {
                  if (state is SupplierLoading) return const Center(child: CircularProgressIndicator());
                  if (state is SupplierFailure) return Center(child: Text(state.message));
                  if (state is SupplierSuccess) {
                    final list = state.listSupplier;
                    if (list.isEmpty) return const Center(child: Text("Belum ada supplier."));
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final supplier = list[index];
                        return ListTile(
                          title: Text("${supplier.nama} (${supplier.jumlah})"),
                          subtitle: Text("Keterangan: ${supplier.keterangan ?? '-'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _fillFormForEdit(supplier),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  if (supplier.id != null) {
                                    context.read<SupplierBloc>().add(DeleteSupplierEvent(id: supplier.id!));
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
