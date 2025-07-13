import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/buah_request_model.dart';
import 'package:pamfix/data/model/response/buah_response_model.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Buah'),
          backgroundColor: Colors.green[800],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add), text: "Form Buah"),
              Tab(icon: Icon(Icons.list), text: "List Buah"),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Buah',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _stokController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<KategoriBloc, KategoriState>(
                      builder: (context, state) {
                        if (state is KategoriSuccess) {
                          return DropdownButtonFormField<int>(
                            value: _selectedKategoriId,
                            decoration: const InputDecoration(
                              labelText: 'Kategori Buah',
                              border: OutlineInputBorder(),
                            ),
                            items: state.listKategori.map((kategori) {
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
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(_editId == null ? "Tambah Buah" : "Update Buah"),
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
          ],
        ),
      ),
    );
  }

  Widget _buildListTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<BuahBloc, BuahState>(
        builder: (context, state) {
          if (state is BuahLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BuahFailure) {
            return Center(child: Text(state.message));
          } else if (state is BuahSuccess) {
            final list = state.listBuah;
            if (list.isEmpty) {
              return const Center(child: Text("Belum ada data buah."));
            }
            return ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final buah = list[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text("${buah.nama} (Stok: ${buah.stok})"),
                    subtitle: Text("Kategori: ${buah.kategoriBuahId != null ? buah.kategoriBuahId.toString() : 'Tidak diketahui'}"),
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
          return const Center(child: Text("Tidak ada data"));
        },
      ),
    );
  }
}
