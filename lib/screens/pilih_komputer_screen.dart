import 'package:flutter/material.dart';
import 'dart:ui';

// Temporary screen for biasa (non-workshop) - ganti dengan screen sesungguhnya nanti
class FormPeminjamanBiasaScreen extends StatelessWidget {
  final String labId;
  final String labName;
  final String tipePeminjaman;
  final DateTime startTime;
  final DateTime endTime;
  final List<int> selectedComputers;

  const FormPeminjamanBiasaScreen({
    super.key,
    required this.labId,
    required this.labName,
    required this.tipePeminjaman,
    required this.startTime,
    required this.endTime,
    required this.selectedComputers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Peminjaman Biasa')),
      body: Center(
        child: Text('Form untuk peminjaman biasa (non-workshop)\nLab: $labName\nKomputer: ${selectedComputers.join(", ")}'),
      ),
    );
  }
}

class PilihKomputerScreen extends StatefulWidget {
  final String labId;
  final String labName;
  final String tipePeminjaman;
  final DateTime startTime;
  final DateTime endTime;

  const PilihKomputerScreen({
    super.key,
    required this.labId,
    required this.labName,
    required this.tipePeminjaman,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<PilihKomputerScreen> createState() => _PilihKomputerScreenState();
}

class _PilihKomputerScreenState extends State<PilihKomputerScreen> {
  List<int> selectedComputers = [];
  List<int> bookedComputers = [2, 5, 7, 12, 15, 18, 22, 28, 33, 38];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Pilih Komputer - ${widget.labName}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade900.withOpacity(0.8),
                Colors.blue.shade600.withOpacity(0.6)
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.blue.shade400
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Status Indikator
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.4), width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusIndicator(Colors.blue, 'Tersedia'),
                        _buildStatusIndicator(Colors.orange, 'Dipilih'),
                        _buildStatusIndicator(Colors.red, 'Sudah Dipinjam'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info,
                              size: 16, color: Colors.white70),
                          const SizedBox(width: 8),
                          Text(
                            widget.tipePeminjaman == 'workshop'
                                ? 'Mode Workshop: Anda dapat memilih beberapa komputer'
                                : 'Mode Non-Workshop: Pilih 1 komputer',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Grid Komputer
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: 40,
                  itemBuilder: (context, index) {
                    final computerNumber = index + 1;
                    final isBooked = bookedComputers.contains(computerNumber);
                    final isSelected =
                        selectedComputers.contains(computerNumber);

                    Color bgColor;
                    Color borderColor;
                    if (isBooked) {
                      bgColor = Colors.red.withOpacity(0.3);
                      borderColor = Colors.red;
                    } else if (isSelected) {
                      bgColor = Colors.orange.withOpacity(0.3);
                      borderColor = Colors.orange;
                    } else {
                      bgColor = Colors.blue.withOpacity(0.2);
                      borderColor = Colors.blue;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (isBooked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Komputer $computerNumber sudah dipinjam'),
                                backgroundColor: Colors.red),
                          );
                        } else {
                          setState(() {
                            if (widget.tipePeminjaman == 'workshop') {
                              if (isSelected) {
                                selectedComputers.remove(computerNumber);
                              } else {
                                selectedComputers.add(computerNumber);
                              }
                            } else {
                              selectedComputers = [computerNumber];
                            }
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.computer, size: 30, color: borderColor),
                            const SizedBox(height: 4),
                            Text(
                              '$computerNumber',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: borderColor),
                            ),
                            Text(
                              isBooked
                                  ? 'Dipesan'
                                  : (isSelected ? 'Dipilih' : 'Tersedia'),
                              style:
                                  TextStyle(fontSize: 10, color: borderColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Tombol Lanjutkan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.2))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: selectedComputers.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormPeminjamanBiasaScreen(
                                  labId: widget.labId,
                                  labName: widget.labName,
                                  tipePeminjaman: widget.tipePeminjaman,
                                  startTime: widget.startTime,
                                  endTime: widget.endTime,
                                  selectedComputers: selectedComputers,
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedComputers.isEmpty ? Colors.grey : Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      selectedComputers.isEmpty
                          ? 'Pilih Komputer Terlebih Dahulu'
                          : 'Lanjutkan (${selectedComputers.length} komputer dipilih)',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)
                ])),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }
}