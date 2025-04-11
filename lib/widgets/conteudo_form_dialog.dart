

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/ocorrencia.dart';

class ConteudoFormDialog extends StatefulWidget{
  final Tarefa? tarefaAtual;

  ConteudoFormDialog({ Key? key, this.tarefaAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog>{

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final prazoControler = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState(){
    super.initState();
    if(widget.tarefaAtual != null){
      descricaoController.text = widget.tarefaAtual!.descricao;
      prazoControler.text = widget.tarefaAtual!.prazoFormatado;
    }
  }

  @override
  Widget build (BuildContext context){
    return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'O campo descrição é obrigatório';
                }
                return null;
              },
            ),
            TextFormField(
              controller: prazoControler,
              decoration: InputDecoration(labelText: 'Prazo',
                prefixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _mostrarCalendario,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => prazoControler.clear(),
                ),
              ),
              readOnly: true,
            ),
          ],
        )
    );
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  void _mostrarCalendario(){
    final dataFormatada = prazoControler.text;
    var data = DateTime.now();
    if ( dataFormatada.isNotEmpty){
      data = _dateFormat.parse(dataFormatada);
    }
    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(Duration(days: 5 * 365)),
      lastDate: data.add(Duration(days: 5 * 365)),
    ).then((DateTime? dataSelecionada){
      if (dataSelecionada != null){
        setState(() {
          prazoControler.text = _dateFormat.format(dataSelecionada);
        });
      }
    });
  }

  Tarefa get novaTarefa => Tarefa(
      id: widget.tarefaAtual?.id ?? 0,
      descricao: descricaoController.text,
      prazo: prazoControler.text.isEmpty ? null : _dateFormat.parse(prazoControler.text)
  );
}