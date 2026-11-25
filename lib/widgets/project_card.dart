import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Kamu telah menekan tombol ${item.name}!'),
              ),
            );

          // Melihat daftar Experience
          if (item.name == "Lihat Proyek") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExperienceListScreen(),
              ),
            );
          }
          // Menambahkan Experience
          else if (item.name == "Tambah Proyek") {
            final allowed = await ensureLoggedIn(context);

            if (!context.mounted || !allowed) return;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
          }
          // Logout
          else if (item.name == "Logout") {
            if (!isLoggedIn) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kamu belum login.')),
              );
              return;
            }

            await context.read<AuthState>().logout();

            if (!context.mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Berhasil logout!')));
          }
        },

        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
