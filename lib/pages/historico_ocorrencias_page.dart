import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dao/ocorrencia_dao.dart';
import '../model/ocorrencia.dart';

class HistoricoOcorrenciasPage extends StatefulWidget {
  @override
  State<HistoricoOcorrenciasPage> createState() => _HistoricoOcorrenciasPageState();
}

class _HistoricoOcorrenciasPageState extends State<HistoricoOcorrenciasPage> {
  final _dao = OcorrenciaDao();
  List<Ocorrencia> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  void _carregarHistorico() async {
    final lista = await _dao.listarHistorico();
    setState(() {
      _historico = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Ocorrências'),
      ),
      body: _historico.isEmpty
          ? Center(child: Text('Nenhuma ocorrência finalizada'))
          : ListView.separated(
        itemCount: _historico.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final o = _historico[index];
          return ListTile(
            title: Text(o.localizacao),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ocorrência: ${DateFormat('dd/MM/yyyy HH:mm').format(o.dataHora)}'),
                Text('Atendido em: ${DateFormat('dd/MM/yyyy HH:mm').format(o.dataHoraAtendimento!)}'),
                Text('Status: ${o.status}')
              ],
            ),
          );
        },
      ),
    );
  }
}
