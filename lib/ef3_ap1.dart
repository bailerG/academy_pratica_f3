import 'package:flutter/material.dart';

const Color cor = Color.fromARGB(255, 244, 242, 222);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: cor,
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final formState = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();

  var ativo = true;

  String? nome;
  int? idade;
  bool? isAtivo;

  bool get isFormularioSalvo {
    return idade != null && nome != null && isAtivo != null;
  }

  void salvaFormulario() {
    if (formState.currentState!.validate()) {
      setState(() {
        nome = nomeController.text;
        idade = int.tryParse(idadeController.text);
        isAtivo = ativo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulário'),
        ),
        body: Form(
            key: formState,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextFormField(
                      controller: nomeController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Center(child: Text('Nome')),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Insira seu nome";
                        }
                        if (value!.length < 2) {
                          return "O nome precisa ter pelo menos 3 letras";
                        }
                        if (value.startsWith(RegExp(r'[^A-Z]'))) {
                          return "O nome precisa iniciar com letra maiúscula";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextFormField(
                      controller: idadeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Center(child: Text('Idade')),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Insira uma idade";
                        }
                        final idade = int.tryParse(idadeController.text) ?? 0;
                        if (idade < 18) {
                          return "Menores não podem ser cadastrados";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: ativo,
                          onChanged: (value) {
                            setState(() {
                              ativo = value!;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(ativo ? 'Ativo' : 'Inativo'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        salvaFormulario();
                      },
                      child: const Text('Salvar')),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Center(child: Text('Informações salvas:')),
                  ),
                  if (isFormularioSalvo)
                    DadosSalvos(nome: nome!, idade: idade!, ativo: isAtivo!)
                ],
              ),
            )));
  }
}

class DadosSalvos extends StatelessWidget {
  const DadosSalvos(
      {required this.nome,
      required this.idade,
      required this.ativo,
      super.key});

  final String nome;
  final int idade;
  final bool ativo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ativo ? Colors.green.shade200 : Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Nome: $nome"),
          Text("Idade: $idade"),
          Text(ativo ? "Ativo" : "Inativo"),
        ],
      ),
    );
  }
}
