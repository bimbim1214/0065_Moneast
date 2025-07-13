import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/model/request/admin/penjualan_request_model.dart';
import 'package:pamfix/presentation/auth/bloc/buah/buah_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/penjualan/penjualan_bloc.dart';

class PenjualanScreen extends StatefulWidget {
  const PenjualanScreen({super.key});

  @override
  State<PenjualanScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  int? selectedBuahId;
  DateTime? selectedTanggal;
  final _jumlahController = TextEditingController();
  final _hargaController = TextEditingController();
  int _currentTotal = 0;
  int? _editId;

  @override
  void initState() {
    super.initState();
    context.read<PenjualanBloc>().add(GetAllPenjualan());
    context.read<BuahBloc>().add(GetAllBuahEvent());

    _jumlahController.addListener(_triggerTotalCalculation);
    _hargaController.addListener(_triggerTotalCalculation);
  }

  void _triggerTotalCalculation() {
    final jumlah = int.tryParse(_jumlahController.text) ?? 0;
    final harga = int.tryParse(_hargaController.text) ?? 0;
    context.read<PenjualanBloc>().add(
          CalculatePenjualanTotalEvent(jumlah: jumlah, harga: harga),
        );
  }

  void _clearForm() {
    setState(() {
      selectedBuahId = null;
      selectedTanggal = null;
      _jumlahController.clear();
      _hargaController.clear();
      _editId = null;
      _currentTotal = 0;
    });
  }

  void _submit() {
    if (selectedBuahId == null ||
        selectedTanggal == null ||
        _jumlahController.text.isEmpty ||
        _hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi!")),
      );
      return;
    }

    final request = PenjualanRequestModel(
      buahId: selectedBuahId,
      jumlah: int.tryParse(_jumlahController.text),
      harga: int.tryParse(_hargaController.text),
      tanggal: selectedTanggal,
    );

    if (_editId == null) {
      context.read<PenjualanBloc>().add(AddPenjualan(request));
    } else {
      context.read<PenjualanBloc>().add(UpdatePenjualan(_editId!, request));
    }

    _clearForm();
  }

  void _fillForm(p) {
    _editId = p.id;
    selectedBuahId = p.buahId;
    selectedTanggal = p.tanggal;
    _jumlahController.text = p.jumlah?.toString() ?? '';
    _hargaController.text = p.harga?.toString() ?? '';
    _triggerTotalCalculation();
    setState(() {});
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Penjualan Buah"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocListener<PenjualanBloc, PenjualanState>(
              listener: (context, state) {
                if (state is PenjualanTotalCalculated) {
                  setState(() {
                    _currentTotal = state.total;
                  });
                }
              },
              child: const SizedBox.shrink(),
            ),

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
                return const LinearProgressIndicator();
              },
            ),
            const SizedBox(height: 10),

            // Jumlah dan Harga
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Jumlah"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Harga"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tanggal
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
                      setState(() => selectedTanggal = picked);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Total
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Total: Rp$_currentTotal",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Tombol Submit
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(_editId == null ? Icons.add : Icons.save),
                  label: Text(_editId == null ? "Tambah" : "Update"),
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const SizedBox(width: 10),
                if (_editId != null)
                  OutlinedButton(
                    onPressed: _clearForm,
                    child: const Text("Batal"),
                  ),
              ],
            ),
            const Divider(height: 32),

            // List Penjualan
            Expanded(
              child: BlocBuilder<PenjualanBloc, PenjualanState>(
                builder: (context, state) {
                  if (state is PenjualanLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PenjualanSuccess) {
                    if (state.penjualanList.isEmpty) {
                      return const Center(child: Text("Belum ada data penjualan."));
                    }
                    return ListView.builder(
                      itemCount: state.penjualanList.length,
                      itemBuilder: (context, index) {
                        final p = state.penjualanList[index];
                        return Card(
                          child: ListTile(
                            title: Text("ID: ${p.id} - Total: Rp${p.totalHarga}"),
                            subtitle: Text("Jumlah: ${p.jumlah}, Harga: ${p.harga}, Tanggal: ${p.tanggal?.toLocal().toString().split(" ")[0]}"),
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
                                      context.read<PenjualanBloc>().add(DeletePenjualan(p.id!));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is PenjualanFailure) {
                    return Center(child: Text(state.error));
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
