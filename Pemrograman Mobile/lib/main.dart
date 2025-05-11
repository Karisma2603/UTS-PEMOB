import 'package:flutter/material.dart';
import 'login.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

bool isLoggedIn = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double saldo = 10000000.0; // Rp. 10.000.000
  List<String> mutasi = [];

  String formatRupiah(double value) {
    return 'Rp. ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _showTransferDialog() {
    final TextEditingController rekeningController = TextEditingController();
    final TextEditingController nominalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Transfer Saldo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rekeningController,
              decoration: InputDecoration(labelText: "Rekening Tujuan"),
            ),
            TextField(
              controller: nominalController,
              decoration: InputDecoration(labelText: "Nominal"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Kirim"),
            onPressed: () {
              final double? nominal = double.tryParse(nominalController.text);
              if (nominal != null && nominal > 0 && nominal <= saldo) {
                setState(() {
                  saldo -= nominal;
                  mutasi.add("Transfer ke ${rekeningController.text}: -${formatRupiah(nominal)}");
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Transfer ke ${rekeningController.text} sebesar ${formatRupiah(nominal)} berhasil.")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Nominal tidak valid atau saldo tidak cukup.")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog() {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Verifikasi Password"),
        content: TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: "Masukkan Password"),
          obscureText: true,
        ),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Lanjut"),
            onPressed: () {
              if (passwordController.text == 'koperasi123') {
                Navigator.pop(context);
                _showQRISDialog();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Password salah!")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showQRISDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("QRIS Pembayaran"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/qrcode.jpg',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 10),
            Text("Scan QRIS untuk melakukan pembayaran"),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Tutup"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showDepositoDialog() {
    final TextEditingController depositoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Buat Deposito"),
        content: TextField(
          controller: depositoController,
          decoration: InputDecoration(labelText: "Nominal"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final double? nominal = double.tryParse(depositoController.text);
              if (nominal != null && nominal > 0 && nominal <= saldo) {
                setState(() {
                  saldo -= nominal;
                  mutasi.add("Deposito dibuat: -${formatRupiah(nominal)}");
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deposito sebesar ${formatRupiah(nominal)} berhasil dibuat.")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Nominal tidak valid atau saldo tidak cukup.")),
                );
              }
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showPinjamanDialog() {
    final TextEditingController pinjamanController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ajukan Pinjaman"),
        content: TextField(
          controller: pinjamanController,
          decoration: InputDecoration(labelText: "Nominal Pinjaman"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final double? nominal = double.tryParse(pinjamanController.text);
              if (nominal != null && nominal > 0) {
                setState(() {
                  saldo += nominal;
                  mutasi.add("Pinjaman diterima: +${formatRupiah(nominal)}");
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pinjaman sebesar ${formatRupiah(nominal)} berhasil.")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Nominal pinjaman tidak valid.")),
                );
              }
            },
            child: Text("Ajukan"),
          ),
        ],
      ),
    );
  }

  void _showMutasiDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Riwayat Mutasi"),
        content: Container(
          width: double.maxFinite,
          child: mutasi.isEmpty
              ? Text("Belum ada mutasi.")
              : ListView(
                  shrinkWrap: true,
                  children: mutasi.map((e) => ListTile(title: Text(e))).toList(),
                ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Tutup")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Koperasi Undiksha"),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('images/foto karisma.jpg'),
                ),
                title: Text("Nasabah\nMaria Karisma Pada Wangge"),
                subtitle: Text("Total Saldo Anda\n${formatRupiah(saldo)}"),
                trailing: Icon(Icons.account_circle, color: Colors.blue[900]),
              ),
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                _buildMenuItem(Icons.account_balance_wallet, "Cek Saldo", onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Saldo Anda"),
                      content: Text(formatRupiah(saldo)),
                      actions: [
                        TextButton(
                          child: Text("Tutup"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }),
                _buildMenuItem(Icons.sync_alt, "Transfer", onTap: _showTransferDialog),
                _buildMenuItem(Icons.savings, "Deposito", onTap: _showDepositoDialog),
                _buildMenuItem(Icons.payment, "Pembayaran", onTap: _showPasswordDialog),
                _buildMenuItem(Icons.attach_money, "Pinjaman", onTap: _showPinjamanDialog),
                _buildMenuItem(Icons.list_alt, "Mutasi", onTap: _showMutasiDialog),
              ],
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.blue[900]),
                title: Text("Butuh Bantuan?"),
                subtitle: Text("0812-3695-7914"),
                trailing: Icon(Icons.call, color: Colors.blue[900]),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomIcon(
                  Icons.settings,
                  "Setting",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                _buildBottomIcon(Icons.qr_code, "", onTap: () {}),
                _buildBottomIcon(Icons.person, "Profile", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue[900], size: 40),
          SizedBox(height: 5),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[900], size: 40),
          SizedBox(height: 5),
          if (title.isNotEmpty) Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
