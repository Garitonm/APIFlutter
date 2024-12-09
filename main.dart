import 'package:flutter/material.dart';
import 'dart:convert'; // Para simular a conversão de JSON

void main() {
  runApp(MyApp());
}

// Classe que representa o modelo de Aluno
class Aluno {
  final String nome;
  final String curso;
  final int idade;
  final String email;

  Aluno({
    required this.nome,
    required this.curso,
    required this.idade,
    required this.email,
  });

  // Método para converter JSON em um objeto Aluno
  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      nome: json['nome'] ?? 'Nome não disponível',
      curso: json['curso'] ?? 'Curso não disponível',
      idade: json['idade'] ?? 0,
      email: json['email'] ?? 'Email não disponível',
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Alunos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Aluno>> _alunos;

  @override
  void initState() {
    super.initState();
    _alunos = fetchAlunos();
  }

  // Simulação de uma requisição de API
  Future<List<Aluno>> fetchAlunos() async {
    // Aqui estamos simulando uma resposta de uma API
    final String response = '''
    [
      {"nome": "Ana Silva", "curso": "Sistemas de Informação", "idade": 20, "email": "ana@email.com"},
      {"nome": "Carlos Souza", "curso": "Engenharia de Software", "idade": 22, "email": "carlos@email.com"},
      {"nome": "João Pereira", "curso": "Ciência da Computação", "idade": 21, "email": "joao@email.com"},
      {"nome": "Maria Santos", "curso": "Design de Interface", "idade": 23, "email": "maria@email.com"}
    ]
    ''';

    // Simulando um pequeno atraso
    await Future.delayed(Duration(seconds: 2));

    // Decodificando o JSON e mapeando os alunos
    List<dynamic> jsonData = json.decode(response);
    return jsonData.map((json) => Aluno.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Alunos'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Aluno>>(
        future: _alunos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum aluno encontrado.'));
          } else {
            final alunos = snapshot.data!;
            return ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aluno.nome,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Curso: ${aluno.curso}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Idade: ${aluno.idade} anos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              aluno.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}