import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../dao/ocorrencia_dao.dart';
import '../model/ocorrencia.dart';

class PaginaPrincipalOcorrencias extends StatefulWidget {
  @override
  State<PaginaPrincipalOcorrencias> createState() => _PaginaPrincipalOcorrenciasState();
}

class _PaginaPrincipalOcorrenciasState extends State<PaginaPrincipalOcorrencias> {
  final _dao = OcorrenciaDao();
  Ocorrencia? _ocorrencia;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _carregarOcorrencia();
  }

  void _carregarOcorrencia() async {
    final ocorrencia = await _dao.obterMaisRecenteNaoFinalizada();
    setState(() {
      _ocorrencia = ocorrencia;
    });
  }

  void _atualizarStatus(String novoStatus) async {
    if (_ocorrencia == null) return;
    final dataAtendimento = novoStatus == 'Finalizada' ? DateTime.now() : null;

    final novaOcorrencia = Ocorrencia(
      id: _ocorrencia!.id,
      localizacao: _ocorrencia!.localizacao,
      dataHora: _ocorrencia!.dataHora,
      dataHoraAtendimento: dataAtendimento ?? _ocorrencia!.dataHoraAtendimento,
      status: novoStatus,
      latitude: _ocorrencia!.latitude,
      longitude: _ocorrencia!.longitude,
    );

    await _dao.salvar(novaOcorrencia);
    _carregarOcorrencia();
  }

  void _mostrarDialogNovaOcorrencia() {
    final localizacaoController = TextEditingController();
    final statusController = TextEditingController();
    DateTime? dataSelecionada;
    LatLng posicaoSelecionada = LatLng(-23.5505, -46.6333);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nova Ocorrência'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: localizacaoController,
                        decoration: InputDecoration(labelText: 'Localização'),
                      ),
                      TextField(
                        controller: statusController,
                        decoration: InputDecoration(labelText: 'Status'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        dataSelecionada == null
                            ? 'Selecione a data'
                            : 'Data: ${DateFormat('dd/MM/yyyy – HH:mm').format(dataSelecionada!)}',
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final data = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (data != null) {
                            final hora = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (hora != null) {
                              setState(() {
                                dataSelecionada = DateTime(
                                  data.year,
                                  data.month,
                                  data.day,
                                  hora.hour,
                                  hora.minute,
                                );
                              });
                            }
                          }
                        },
                        child: Text('Selecionar Data'),
                      ),
                      SizedBox(height: 20),
                      Text('Toque no mapa para ajustar a localização:'),
                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: posicaoSelecionada,
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('selecao'),
                              position: posicaoSelecionada,
                            ),
                          },
                          onTap: (LatLng novaPosicao) {
                            setState(() {
                              posicaoSelecionada = novaPosicao;
                            });
                          },
                          onMapCreated: (controller) {},
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (localizacaoController.text.isEmpty ||
                    statusController.text.isEmpty ||
                    dataSelecionada == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos')),
                  );
                  return;
                }

                final nova = Ocorrencia(
                  localizacao: localizacaoController.text,
                  dataHora: dataSelecionada!,
                  status: statusController.text,
                  latitude: posicaoSelecionada.latitude,
                  longitude: posicaoSelecionada.longitude,
                );

                await _dao.salvar(nova);
                _carregarOcorrencia();
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ocorrência Atual'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/historico'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Nova Ocorrência',
            onPressed: _mostrarDialogNovaOcorrencia,
          )
        ],
      ),
      body: _ocorrencia == null
          ? Center(child: Text('Nenhuma ocorrência em andamento'))
          : Column(
            children: [
              SizedBox(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_ocorrencia!.latitude, _ocorrencia!.longitude),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('local'),
                      position: LatLng(_ocorrencia!.latitude, _ocorrencia!.longitude),
                    )
                  },
                  onMapCreated: (controller) => _mapController = controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Localização: ${_ocorrencia!.localizacao}'),
                    Text('Data/Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(_ocorrencia!.dataHora)}'),
                    if (_ocorrencia!.dataHoraAtendimento != null)
                      Text('Atendido em: ${DateFormat('dd/MM/yyyy HH:mm').format(_ocorrencia!.dataHoraAtendimento!)}'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status: ${_ocorrencia!.status}'),
                        ElevatedButton(
                          onPressed: () {
                            if (_ocorrencia!.status == 'Pendente') {
                              _atualizarStatus('Em atendimento');
                            } else if (_ocorrencia!.status == 'Em atendimento') {
                              _atualizarStatus('Finalizada');
                            }
                          },
                          child: Text(
                            _ocorrencia!.status == 'Pendente'
                                ? 'Atender'
                                : _ocorrencia!.status == 'Em atendimento'
                                ? 'Finalizar'
                                : 'Concluído',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}