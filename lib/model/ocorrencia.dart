import 'package:intl/intl.dart';

class Ocorrencia {
  static const String nomeTabela = 'ocorrencia';
  static const String CAMPO_ID = '_id';
  static const String CAMPO_LOCALIZACAO = 'localizacao';
  static const String CAMPO_DATA_HORA = 'dataHora';
  static const String CAMPO_DATA_ATENDIMENTO = 'dataHoraAtendimento';
  static const String CAMPO_STATUS = 'status';
  static const String CAMPO_LATITUDE = 'latitude';
  static const String CAMPO_LONGITUDE = 'longitude';

  int? id;
  String localizacao;
  DateTime dataHora;
  DateTime? dataHoraAtendimento;
  String status;
  double latitude;
  double longitude;

  Ocorrencia({
    this.id,
    required this.localizacao,
    required this.dataHora,
    this.dataHoraAtendimento,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() => {
    CAMPO_ID: id,
    CAMPO_LOCALIZACAO: localizacao,
    CAMPO_DATA_HORA: DateFormat("yyyy-MM-dd HH:mm:ss").format(dataHora),
    CAMPO_DATA_ATENDIMENTO: dataHoraAtendimento == null ? null : DateFormat("yyyy-MM-dd HH:mm:ss").format(dataHoraAtendimento!),
    CAMPO_STATUS: status,
    CAMPO_LATITUDE: latitude,
    CAMPO_LONGITUDE: longitude,
  };

  factory Ocorrencia.fromMap(Map<String, dynamic> map) => Ocorrencia(
    id: map[CAMPO_ID],
    localizacao: map[CAMPO_LOCALIZACAO],
    dataHora: DateFormat("yyyy-MM-dd HH:mm:ss").parse(map[CAMPO_DATA_HORA]),
    dataHoraAtendimento: map[CAMPO_DATA_ATENDIMENTO] == null ? null : DateFormat("yyyy-MM-dd HH:mm:ss").parse(map[CAMPO_DATA_ATENDIMENTO]),
    status: map[CAMPO_STATUS],
    latitude: map[CAMPO_LATITUDE],
    longitude: map[CAMPO_LONGITUDE],
  );
}
