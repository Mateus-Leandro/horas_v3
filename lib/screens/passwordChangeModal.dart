import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class PasswordChangeModal extends StatefulWidget {
  const PasswordChangeModal({super.key});

  @override
  State<PasswordChangeModal> createState() => _PasswordchangemodalState();
}

class _PasswordchangemodalState extends State<PasswordChangeModal> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  final _user = FirebaseAuth.instance.currentUser;
  final AuthService authService = AuthService();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alteração de senha'),
      actions: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(labelText: 'Senha atual'),
                  controller: _senhaController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Senha inválida.';
                    }
                    return null;
                  }),
              if (_errorMessage != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
              TextFormField(
                decoration: InputDecoration(labelText: 'Nova senha'),
                controller: _novaSenhaController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Senha inválida.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirme a nova senha'),
                controller: _confirmaSenhaController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Senha inválida.';
                  }
                  if (_novaSenhaController.text !=
                      _confirmaSenhaController.text) {
                    return 'As Senhas informadas não condizem';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        authService
                            .alterarSenha(
                                senhaAtual: _senhaController.text,
                                novaSenha: _confirmaSenhaController.text)
                            .then((error) {
                          if (error != null) {
                            setState(() {
                              _errorMessage = error;
                            });
                          } else {
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                    child: Text('Confirmar'),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
