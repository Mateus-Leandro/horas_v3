import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:horas_v3/screens/delete_user_modal.dart';
import 'package:horas_v3/services/auth_service.dart';

import '../screens/passwordChangeModal.dart';

class Menu extends StatelessWidget {
  final User user;

  const Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.manage_accounts_rounded,
                size: 48,
              ),
            ),
            accountName:
            Text((user.displayName != null) ? user.displayName! : ''),
            accountEmail: Text(user.email!),
          ),
          if (!googleUser()) ...{
            ListTile(
              leading: Icon(Icons.key),
              title: const Text('Alterar Senha'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PasswordChangeModal();
                    });
              },
            ),
          },
          ListTile(
            leading: Icon(Icons.delete),
            title: const Text('Excluir Conta'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteUserModal();
                  });
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              AuthService().deslogar();
            },
          ),
        ],
      ),
    );
  }

  bool googleUser() {
    for (final userInfo in user.providerData) {
      if (userInfo.providerId == 'google.com') {
        return true;
      }
    }
    return false;
  }
}
