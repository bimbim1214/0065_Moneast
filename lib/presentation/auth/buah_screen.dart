import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/buah_request_model.dart';
import 'package:pamfix/presentation/auth/bloc/buah/buah_bloc.dart';

class BuahScreen extends StatefulWidget {
  const BuahScreen({super.key});

  @override
  State<BuahScreen> createState() => _BuahScreenState();
}

class _BuahScreenState extends State<BuahScreen> {
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BuahBloc>().add(GetAllBuahEvent());
  }

  void _submitForm() {
    final nama = _namaController.text;
    final stok = int.tryParse(_stokController.text) ?? 0;

    if (nama.isNotEmpty) {
      final buah = BuahRequestModel(nama: nama, stok: stok);
      context.read<BuahBloc>().add(AddBuahEvent(buah: buah));
      _namaController.clear();
      _stokController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Buah")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form input buah
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: "Nama Buah"),
            ),
            TextField(
              controller: _stokController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Stok"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("Tambah Buah"),
            ),
            const SizedBox(height: 20),

            // List buah
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
                        return ListTile(
                          title: Text("${buah.nama} (${buah.stok})"),
                          subtitle: Text("ID: ${buah.id}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              if (buah.id != null) {
                                context.read<BuahBloc>().add(DeleteBuahEvent(id: buah.id!));
                              }
                            },
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
