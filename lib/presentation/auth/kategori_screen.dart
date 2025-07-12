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
          decoration: const InputDecoration(hintText: "Nama Kategori"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _namaKategoriController.clear();
              Navigator.pop(context);
            },
            child: const Text("Batal"),
          ),
          ElevatedButton(
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
            child: const Text("Simpan"),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<KategoriBloc>().add(DeleteKategoriEvent(id: id));
              Navigator.pop(context);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategori Buah")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showKategoriDialog(),
        child: const Icon(Icons.add),
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

            return ListView.builder(
              itemCount: state.listKategori.length,
              itemBuilder: (context, index) {
                final kategori = state.listKategori[index];
                return ListTile(
                  title: Text(kategori.namaKategori ?? '-'),
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
