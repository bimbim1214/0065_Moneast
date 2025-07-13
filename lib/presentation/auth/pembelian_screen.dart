import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/pembelian_request_model.dart';
import 'package:pamfix/data/model/response/buah_response_model.dart';
import 'package:pamfix/data/model/response/supplier_response_model.dart';
import 'package:pamfix/presentation/auth/bloc/buah/buah_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/supplier/supplier_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/pembelian/pembelian_bloc.dart';

class PembelianScreen extends StatefulWidget {
  const PembelianScreen({super.key});

  @override
  State<PembelianScreen> createState() => _PembelianScreenState();
}

class _PembelianScreenState extends State<PembelianScreen> {
  int? selectedBuahId;
  int? selectedSupplierId;
  int? _editId;

  final _jumlahController = TextEditingController();
  final _hargaController = TextEditingController();
  DateTime? selectedTanggal;

  @override
  void initState() {
    super.initState();
    context.read<PembelianBloc>().add(GetAllPembelianEvent());
    context.read<BuahBloc>().add(GetAllBuahEvent());
    context.read<SupplierBloc>().add(GetAllSupplierEvent());
  }

  void _clearForm() {
    _editId = null;
    selectedBuahId = null;
    selectedSupplierId = null;
    selectedTanggal = null;
    _jumlahController.clear();
    _hargaController.clear();
    setState(() {});
  }

  void _submit() {
    if (selectedBuahId == null ||
        selectedSupplierId == null ||
        _jumlahController.text.isEmpty ||
        _hargaController.text.isEmpty ||
        selectedTanggal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi!")),
      );
      return;
    }

    final request = PembelianRequestModel(
      buahId: selectedBuahId,
      supplierId: selectedSupplierId,
      jumlah: int.tryParse(_jumlahController.text),
      harga: int.tryParse(_hargaController.text),
      tanggal: selectedTanggal,
    );

    if (_editId == null) {
      context.read<PembelianBloc>().add(AddPembelianEvent(request));
    } else {
      context.read<PembelianBloc>().add(UpdatePembelianEvent(_editId!, request));
    }

    _clearForm();
  }

  void _fillForm(pembelian) {
    _editId = pembelian.id;
    selectedBuahId = pembelian.buahId;
    selectedSupplierId = pembelian.supplierId;
    _jumlahController.text = pembelian.jumlah?.toString() ?? '';
    _hargaController.text = pembelian.harga?.toString() ?? '';
    selectedTanggal = pembelian.tanggal;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembelian Buah")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown Buah
            BlocBuilder<BuahBloc, BuahState>(
              builder: (context, state) {
                if (state is BuahSuccess) {
                  return DropdownButtonFormField<int>(
                    value: selectedBuahId,
                    items: state.listBuah
                        .map((buah) => DropdownMenuItem(
                              value: buah.id,
                              child: Text(buah.nama ?? '-'),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedBuahId = val),
                    decoration: const InputDecoration(labelText: "Pilih Buah"),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),

            // Dropdown Supplier
            BlocBuilder<SupplierBloc, SupplierState>(
              builder: (context, state) {
                if (state is SupplierSuccess) {
                  return DropdownButtonFormField<int>(
                    value: selectedSupplierId,
                    items: state.listSupplier
                        .map((s) => DropdownMenuItem(
                              value: s.id,
                              child: Text(s.nama ?? '-'),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedSupplierId = val),
                    decoration: const InputDecoration(labelText: "Pilih Supplier"),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),

            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah"),
            ),
            TextField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Harga"),
            ),

            const SizedBox(height: 10),

            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: selectedTanggal != null
                    ? "${selectedTanggal!.year.toString().padLeft(4, '0')}-${selectedTanggal!.month.toString().padLeft(2, '0')}-${selectedTanggal!.day.toString().padLeft(2, '0')}"
                    : '',
              ),
              decoration: InputDecoration(
                labelText: 'Tanggal',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedTanggal ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTanggal = picked;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_editId == null ? "Tambah" : "Update"),
                ),
                const SizedBox(width: 10),
                if (_editId != null)
                  TextButton(
                    onPressed: _clearForm,
                    child: const Text("Batal"),
                  ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            // Daftar pembelian
            Expanded(
              child: BlocBuilder<PembelianBloc, PembelianState>(
                builder: (context, state) {
                  if (state is PembelianLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PembelianSuccess) {
                    return ListView.builder(
                      itemCount: state.listPembelian.length,
                      itemBuilder: (context, index) {
                        final p = state.listPembelian[index];
                        return ListTile(
                          title: Text("${p.namaBuah} - ${p.namaSupplier}"),
                          subtitle: Text(
                            "Jumlah: ${p.jumlah}, Harga: ${p.harga}, Tanggal: ${p.tanggal?.toLocal().toString().split(' ')[0]}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _fillForm(p),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  if (p.id != null) {
                                    context
                                        .read<PembelianBloc>()
                                        .add(DeletePembelianEvent(p.id!));
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is PembelianFailure) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
