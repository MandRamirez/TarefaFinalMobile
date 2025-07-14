import 'package:flutter/material.dart';

class UserSidebar extends StatelessWidget {
  final VoidCallback? onLogout;

  const UserSidebar({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Acessa o tema atual

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Matías Ramírez"),
            accountEmail: const Text("mandramirezport@outlook.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/user_avatar.png"),
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary, // Usa a cor do tema!
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text("Mapa"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Configurações"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/configuracoes');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sair"),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
