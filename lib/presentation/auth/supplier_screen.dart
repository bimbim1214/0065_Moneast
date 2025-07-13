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
    context.read<BuahBloc>().add(GetAllBuahEvent());
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manajemen Supplier"),
          backgroundColor: Colors.green[800],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add), text: "Form Supplier"),
              Tab(icon: Icon(Icons.list), text: "Daftar Supplier"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFormTab(),
            _buildListTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField(_namaController, "Nama Supplier"),
              const SizedBox(height: 12),
              _buildTextField(_alamatController, "Alamat"),
              const SizedBox(height: 12),
              _buildTextField(_teleponController, "Telepon"),
              const SizedBox(height: 12),
              _buildTextField(_jumlahController, "Jumlah", isNumber: true),
              const SizedBox(height: 12),
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
                      decoration: const InputDecoration(
                        labelText: "Pilih Buah",
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_editId == null ? "Tambah Supplier" : "Update Supplier"),
                    ),
                  ),
                  if (_editId != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearForm,
                        child: const Text("Batal"),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<SupplierBloc, SupplierState>(
        builder: (context, state) {
          if (state is SupplierLoading) return const Center(child: CircularProgressIndicator());
          if (state is SupplierFailure) return Center(child: Text(state.message));
          if (state is SupplierSuccess) {
            final list = state.listSupplier;
            if (list.isEmpty) return const Center(child: Text("Belum ada supplier."));
            return ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final s = list[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text("${s.nama} (Jumlah: ${s.jumlah})"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Alamat: ${s.alamat ?? '-'}"),
                        Text("Telepon: ${s.telepon ?? '-'}"),
                        Text("Buah: ${s.keterangan ?? '-'}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _fillFormForEdit(s),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (s.id != null) {
                              context.read<SupplierBloc>().add(DeleteSupplierEvent(id: s.id!));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
