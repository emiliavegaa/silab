import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/peminjaman_lab_provider.dart';

class RiwayatPeminjamanLabScreen extends StatelessWidget {
  const RiwayatPeminjamanLabScreen({super.key});

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Persetujuan';
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PeminjamanLabProvider>(context);
    final riwayat = provider.riwayat;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Riwayat Peminjaman Lab',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
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
              Colors.blue.shade400,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: riwayat.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.computer_rounded,
                        size: 80,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada riwayat peminjaman lab',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: riwayat.length,
                  itemBuilder: (context, index) {
                    final item = riwayat[index];
                    final statusColor = _getStatusColor(item.status);
                    final statusText = _getStatusText(item.status);

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Colors.blue.shade900,
                            title: const Text(
                              'Detail Peminjaman Lab',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(Icons.computer_rounded,
                                    'Laboratorium', item.lab),
                                const SizedBox(height: 8),
                                _buildDetailRow(Icons.person_rounded,
                                    'Peminjam', item.nama),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                    Icons.badge_rounded, 'NIM', item.nim),
                                const SizedBox(height: 8),
                                _buildDetailRow(Icons.calendar_today_rounded,
                                    'Tanggal', item.tanggal),
                                const SizedBox(height: 8),
                                _buildDetailRow(Icons.access_time_rounded,
                                    'Waktu', item.waktu),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                    Icons.info_rounded, 'Status', statusText,
                                    statusColor: statusColor),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.cyan,
                                ),
                                child: const Text('Tutup'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.4), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Icon Lab
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [Colors.blue, Colors.cyan]),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.5),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.computer_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Informasi Peminjaman
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.lab,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.person_rounded,
                                            size: 12, color: Colors.white70),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            '${item.nama} (${item.nim})',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today_rounded,
                                            size: 12, color: Colors.white70),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.tanggal,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.access_time_rounded,
                                            size: 12, color: Colors.white70),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.waktu,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      statusColor,
                                      statusColor.withOpacity(0.7)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusColor.withOpacity(0.5),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  statusText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? statusColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: statusColor ?? Colors.white,
              fontWeight:
                  statusColor != null ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
