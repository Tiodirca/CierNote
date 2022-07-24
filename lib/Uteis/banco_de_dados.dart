import 'dart:io';
import 'package:ciernote/Uteis/constantes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class BancoDeDados {
  static const bancoDadosNome = Constantes.nomeBanco;
  static const bancoDadosVersao = 1;
  static const table = Constantes.nomeTabela;
  static const columnId = Constantes.bancoId;
  static const columnTarefaTitulo = Constantes.bancoTitulo;
  static const columnTarefaConteudo = Constantes.bancoConteudo;
  static const columnTarefaCor = Constantes.bancoCor;
  static const columnTarefaData = Constantes.bancoData;
  static const columnTarefaHora = Constantes.bancoHora;
  static const columnTarefaStatus = Constantes.bancoStatus;
  static const columnTarefaFavorito = Constantes.bancoFavorito;
  static const columnTarefaNotificacao = Constantes.bancoNotificacao;

  // torna a clase singleton
  BancoDeDados._privateConstructor();

  static final BancoDeDados instance = BancoDeDados._privateConstructor();

  // tem somente uma referência ao banco de dados
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, bancoDadosNome);
    return await openDatabase(path,
        version: bancoDadosVersao, onCreate: _onCreate);
  }

  // Código SQL para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTarefaTitulo TEXT NOT NULL,
            $columnTarefaConteudo TEXT NOT NULL,
            $columnTarefaCor TEXT NOT NULL,
            $columnTarefaHora TEXT NOT NULL,
            $columnTarefaData TEXT NOT NULL,
            $columnTarefaStatus TEXT NOT NULL,
            $columnTarefaFavorito BIT NOT NULL,
            $columnTarefaNotificacao BIT NOT NULL
          )
          ''');
  }

  // métodos auxiliares
  // metodo para inserir dados no banco
  // uma linha e inserida onde cada chave
  // no Map é um nome de coluna e o valor é o valor da coluna.
  Future<int> inserir(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // metodo para realizr a consuta no banco de dados de todas as linhas
  // elas são retornadas como uma lista de mapas
  Future<List<Map<String, dynamic>>> consultarLinhas() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<List<Map<String, dynamic>>> consultarPorID(String idDado) async {
    Database? db = await instance.database;
    return await db!.query("$table WHERE id = $idDado");
  }

  // metodo para atualizar os dados
  // a coluna id no mapa está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  Future<int> atualizar(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // metodo para excluir a linha especificada pelo id.
  Future<int> excluir(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
