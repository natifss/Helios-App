import 'package:helios/database/database_provider.dart';
import '../model/ocorrencia.dart';

class OcorrenciaDao {
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Ocorrencia ocorrencia) async {
    final db = await dbProvider.database;
    final valores = ocorrencia.toMap();
    if (ocorrencia.id == null) {
      ocorrencia.id = await db.insert(Ocorrencia.nomeTabela, valores);
      return true;
    } else {
      final registrosAtualizados = await db.update(
        Ocorrencia.nomeTabela,
        valores,
        where: '${Ocorrencia.CAMPO_ID} = ?',
        whereArgs: [ocorrencia.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<List<Ocorrencia>> listarTodas() async {
    final db = await dbProvider.database;
    final resultado = await db.query(Ocorrencia.nomeTabela);
    return resultado.map((map) => Ocorrencia.fromMap(map)).toList();
  }

  Future<Ocorrencia?> obterMaisRecenteNaoFinalizada() async {
    final db = await dbProvider.database;
    final resultado = await db.query(
      Ocorrencia.nomeTabela,
      where: '${Ocorrencia.CAMPO_STATUS} != ?',
      whereArgs: ['Finalizada'],
      orderBy: '${Ocorrencia.CAMPO_DATA_HORA} DESC',
      limit: 1,
    );
    if (resultado.isEmpty) return null;
    return Ocorrencia.fromMap(resultado.first);
  }

  Future<List<Ocorrencia>> listarHistorico() async {
    final db = await dbProvider.database;
    final resultado = await db.query(
        Ocorrencia.nomeTabela,
        where: '${Ocorrencia.CAMPO_STATUS} = ?',
        whereArgs: ['Finalizada'],
        orderBy: '${Ocorrencia.CAMPO_DATA_HORA} DESC'
    );
    return resultado.map((map) => Ocorrencia.fromMap(map)).toList();
  }
}
