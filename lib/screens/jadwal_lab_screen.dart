import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jadwal_provider.dart';

class JadwalLabScreen extends StatelessWidget {
  const JadwalLabScreen({super.key});

  String _getMonthName(int month) => [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ][month - 1];

  @override
  Widget build(BuildContext context) {
    final jadwalProvider = Provider.of<JadwalProvider>(context);
    final jadwal = jadwalProvider.jadwal;
    final today = DateTime.now();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Jadwal Laboratorium',
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
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Header hari ini dengan efek glassmorphism
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.blue.shade200.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: Colors.blue.shade300.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade300.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.cyan]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 8),
                        ],
                      ),
                      child: const Icon(Icons.calendar_today,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jadwal Hari Ini',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        Text(
                          '${today.day} ${_getMonthName(today.month)} ${today.year}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // List jadwal
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jadwal.length,
                  itemBuilder: (context, index) {
                    final item = jadwal[index];
                    Color statusColor;
                    if (item.status == 'Tersedia') {
                      statusColor = Colors.green;
                    } else if (item.status == 'Dipesan (Workshop)') {
                      statusColor = Colors.orange;
                    } else {
                      statusColor = Colors.red;
                    }
                    return Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon status dengan efek glow
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: statusColor.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                item.status == 'Tersedia'
                                    ? Icons.check_circle_rounded
                                    : (item.status == 'Dipesan (Workshop)'
                                        ? Icons.event_busy_rounded
                                        : Icons.schedule_rounded),
                                color: statusColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Informasi jadwal
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.lab,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  if (item.jam != '-')
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded,
                                            size: 14, color: Colors.white70),
                                        const SizedBox(width: 4),
                                        Text(item.jam,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70)),
                                      ],
                                    ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.book_rounded,
                                          size: 14, color: Colors.white70),
                                      const SizedBox(width: 4),
                                      Text(item.kegiatan,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70)),
                                    ],
                                  ),
                                  if (item.dosen != '-')
                                    Row(
                                      children: [
                                        const Icon(Icons.person_rounded,
                                            size: 14, color: Colors.white70),
                                        const SizedBox(width: 4),
                                        Text(item.dosen,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70)),
                                      ],
                                    ),
                                  if (item.catatan != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '📝 ${item.catatan}',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white60),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Status badge
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
                                item.status,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
