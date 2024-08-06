import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horas_v3/services/auth_service.dart';

class DeleteUserModal extends StatefulWidget {
  const DeleteUserModal({super.key});

  @override
  State<DeleteUserModal> createState() => _DeleteUserModalState();
}

class _DeleteUserModalState extends State<DeleteUserModal> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _user = FirebaseAuth.instance.currentUser;
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    for (final userInfo in _user!.providerData) {
      if (userInfo.providerId == "google.com") {
        return showDeleteGoogleUser();
      }
    }
    return showDeleteUser();
  }

  Widget showDeleteUser() {
    return AlertDialog(
      title: Text('Excluir conta.'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _senhaController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Digite sua senha.'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Senha inválida';
            }
            return null;
          },
        ),
      ),
      actions: <TextButton>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')),
        TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await authService
                    .excluirConta(senha: _senhaController.text)
                    .then((String? erro) {
                  Navigator.of(context).pop();
                  if (erro != null) {
                    final snackBar = SnackBar(
                      content: Text('Erro ao excluir usuário'),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              }
            },
            child: Text('Exclusão de usuário.'))
      ],
    );
  }

  Widget showDeleteGoogleUser() {
    return AlertDialog(
      title: Text('Excluir conta.'),
      actions: <TextButton>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')),
        TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authService.excluirConta(senha: null).then((String? erro) {
                if (erro != null) {
                  final snackBar = SnackBar(
                    content: Text('Erro ao excluir usuário'),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  final snackBar = SnackBar(
                      content: Text(
                          'Usuário removido: ${FirebaseAuth.instance.currentUser!.email}'),
                      backgroundColor: Colors.green);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              });
            },
            child: Text('Exclusão de usuário.'))
      ],
    );
  }
}
