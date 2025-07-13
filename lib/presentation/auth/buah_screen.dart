import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/buah_request_model.dart';
import 'package:pamfix/data/model/response/buah_response_model.dart';
import 'package:pamfix/data/model/response/kategori_response_model.dart';
import 'package:pamfix/presentation/auth/bloc/buah/buah_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/kategori/kategori_bloc.dart';

class BuahScreen extends StatefulWidget {
  const BuahScreen({super.key});

  @override
  State<BuahScreen> createState() => _BuahScreenState();
}

class _BuahScreenState extends State<BuahScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  int? _selectedKategoriId;
  int? _editId;

  @override
  void initState() {
    super.initState();
    context.read<BuahBloc>().add(GetAllBuahEvent());
    context.read<KategoriBloc>().add(GetAllKategoriEvent());
  }

  void _submitForm() {
    final nama = _namaController.text.trim();
    final stok = int.tryParse(_stokController.text.trim()) ?? 0;

    if (nama.isEmpty || stok <= 0 || _selectedKategoriId == null) return;

    final buah = BuahRequestModel(
      nama: nama,
      stok: stok,
      kategoriBuahId: _selectedKategoriId,
    );

    if (_editId == null) {
      context.read<BuahBloc>().add(AddBuahEvent(buah: buah));
    } else {
      context.read<BuahBloc>().add(UpdateBuahEvent(id: _editId!, buah: buah));
    }

    _clearForm();
  }

  void _fillFormForEdit(BuahResponsesModel buah) {
    _namaController.text = buah.nama ?? '';
    _stokController.text = buah.stok?.toString() ?? '';
    _selectedKategoriId = buah.kategoriBuahId;
    _editId = buah.id;
    setState(() {});
  }

  void _clearForm() {
    _namaController.clear();
    _stokController.clear();
    _selectedKategoriId = null;
    _editId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Buah')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Buah'),
            ),
            TextField(
              controller: _stokController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stok'),
            ),
            const SizedBox(height: 12),
            BlocBuilder<KategoriBloc, KategoriState>(
              builder: (context, state) {
                if (state is KategoriSuccess) {
                  final list = state.listKategori;
                  return DropdownButtonFormField<int>(
                    value: _selectedKategoriId,
                    decoration: const InputDecoration(labelText: 'Kategori Buah'),
                    items: list.map((kategori) {
                      return DropdownMenuItem(
                        value: kategori.id,
                        child: Text(kategori.namaKategori ?? '-'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedKategoriId = value;
                      });
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_editId == null ? "Tambah Buah" : "Update Buah"),
                ),
                if (_editId != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _clearForm,
                    child: const Text("Batal"),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<BuahBloc, BuahState>(
                builder: (context, state) {
                  if (state is BuahLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BuahFailure) {
                    return Center(child: Text(state.message));
                  } else if (state is BuahSuccess) {
                    final list = state.listBuah;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final buah = list[index];
                        return Card(
                          child: ListTile(
                            title: Text("${buah.nama} (${buah.stok})"),
                            subtitle: Text("Kategori ID: ${buah.kategoriBuahId}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _fillFormForEdit(buah),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    if (buah.id != null) {
                                      context.read<BuahBloc>().add(DeleteBuahEvent(id: buah.id!));
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
                  return const Text("Tidak ada data");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
