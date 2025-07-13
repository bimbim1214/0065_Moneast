import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/kategori_request_model.dart';
import 'package:pamfix/presentation/auth/bloc/kategori/kategori_bloc.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final TextEditingController _namaKategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<KategoriBloc>().add(GetAllKategoriEvent());
  }

  void _showKategoriDialog({int? id, String? currentName}) {
    _namaKategoriController.text = currentName ?? "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? "Tambah Kategori" : "Edit Kategori"),
        content: TextField(
          controller: _namaKategoriController,
          decoration: const InputDecoration(
            labelText: "Nama Kategori",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              _namaKategoriController.clear();
              Navigator.pop(context);
            },
            child: const Text("Batal"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Simpan"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              final kategori = KategoriRequestModel(
                namaKategori: _namaKategoriController.text,
              );

              if (id == null) {
                context.read<KategoriBloc>().add(AddKategoriEvent(kategori: kategori));
              } else {
                context.read<KategoriBloc>().add(UpdateKategoriEvent(id: id, kategori: kategori));
              }

              _namaKategoriController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Kategori"),
        content: const Text("Apakah Anda yakin ingin menghapus kategori ini?"),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text("Hapus"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<KategoriBloc>().add(DeleteKategoriEvent(id: id));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategori Buah"),
        backgroundColor: Colors.green[800],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () => _showKategoriDialog(),
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
      body: BlocBuilder<KategoriBloc, KategoriState>(
        builder: (context, state) {
          if (state is KategoriLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KategoriFailure) {
            return Center(child: Text(state.message));
          } else if (state is KategoriSuccess) {
            if (state.listKategori.isEmpty) {
              return const Center(child: Text("Belum ada kategori."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.listKategori.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final kategori = state.listKategori[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.category, color: Colors.white),
                    ),
                    title: Text(
                      kategori.namaKategori ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("ID: ${kategori.id}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showKategoriDialog(
                            id: kategori.id,
                            currentName: kategori.namaKategori,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(kategori.id!),
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
}
