import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horas_v3/helpers/hour_helpers.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

import '../components/menu.dart';
import '../models/hour.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Hour> listHours = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(user: widget.user),
      appBar: AppBar(
        title: Text('Horas v3'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: Icon(Icons.add),
      ),
      body: (listHours.isEmpty)
          ? const Center(
              child: Text('Nada por aqui.\nVamos registrar um dia de trabalho',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            )
          : ListView(
              padding: EdgeInsets.only(left: 4, right: 4),
              children: List.generate(listHours.length, (index) {
                Hour model = listHours[index];
                return Dismissible(
                  key: ValueKey<Hour>(model),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 12),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    remove(model);
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                          onLongPress: () {},
                          onTap: () {},
                          leading: Icon(
                            Icons.list_alt_rounded,
                            size: 56,
                          ),
                          title: Text(
                              'Data: ${model.data} hora: ${HourHelpers.minutosToHours(
                            model.minutos,
                          )}'),
                          subtitle: Text(model.descricao!),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }

  showFormModal({Hour? model}) {
    String title = "Adicionar";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    TextEditingController dataController = TextEditingController();
    final dataMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');
    TextEditingController minutosController = TextEditingController();
    final minutosMaskFormatter = MaskTextInputFormatter(mask: '##:##');
    TextEditingController descricaoController = TextEditingController();

    if (model != null) {
      title = "Editando";
      dataController.text = model.data;
      minutosController.text = HourHelpers.minutosToHours(model.minutos);
      if (model.descricao != null) {
        descricaoController.text = model.descricao!;
      }
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(32),
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: dataController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: '01/01/2024',
                  labelText: 'Data',
                ),
                inputFormatters: [dataMaskFormatter],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: minutosController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '00:00',
                  labelText: 'Horas trabalhadas',
                ),
                inputFormatters: [minutosMaskFormatter],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descricaoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Lembrete do que você fez',
                    labelText: 'Descrição'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Hour hour = Hour(
                          id: const Uuid().v1(),
                          data: dataController.text,
                          minutos: HourHelpers.hoursToMinutos(
                            minutosController.text,
                          ));
                      if (descricaoController.text != "") {
                        hour.descricao = descricaoController.text;
                      }

                      if (model != null) {
                        hour.id = model.id;
                      }

                      firestore
                          .collection(widget.user.uid)
                          .doc(hour.id)
                          .set(hour.toMap());

                      refresh();

                      Navigator.pop(context);
                    },
                    child: Text(confirmationButton),
                  ),
                ],
              ),
              SizedBox(height: 180)
            ],
          ),
        );
      },
    );
  }

  void remove(Hour model) {
    firestore.collection(widget.user.uid).doc(model.id).delete();
    refresh();
  }
}

void refresh() {}
