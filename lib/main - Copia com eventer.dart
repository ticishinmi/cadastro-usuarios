import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Usuários',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const UserListPage(),
    );
  }
}

class User {
  String name;
  int age;
  String gender;

  User({
    required this.name,
    required this.age,
    required this.gender,
  });
}

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final List<User> users = [];

  Future<void> _openForm({User? user, int? index}) async {
    final result = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (_) => UserFormPage(user: user),
      ),
    );

    if (result != null) {
      setState(() {
        if (index == null) {
          users.add(result);
        } else {
          users[index] = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Lista de Usuários'),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.person_add),
              label: const Text('Adicionar'),
            ),
          ],
        ),
      ),
      body: users.isEmpty
          ? const Center(
              child: Text('Nenhum usuário cadastrado'),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.name),
                    subtitle: Text(
                      'Idade: ${user.age} | Sexo: ${user.gender}',
                    ),
                    onTap: () => _openForm(user: user, index: index),
                  ),
                );
              },
            ),
    );
  }
}

class UserFormPage extends StatefulWidget {
  final User? user;

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController ageController;

  late FocusNode nameFocusNode;
  late FocusNode ageFocusNode;
  late FocusNode genderFocusNode;

  String? gender;

  final List<String> genders = [
    'Masculino',
    'Feminino',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.user?.name ?? '');

    ageController =
        TextEditingController(text: widget.user?.age.toString() ?? '');

    gender = widget.user?.gender;

    nameFocusNode = FocusNode();
    ageFocusNode = FocusNode();
    genderFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.user == null) {
        nameFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    nameFocusNode.dispose();
    ageFocusNode.dispose();
    genderFocusNode.dispose();
    super.dispose();
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: nameController.text.trim(),
        age: int.parse(ageController.text),
        gender: gender!,
      );

      Navigator.pop(context, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user == null ? 'Novo Usuário' : 'Editar Usuário',
        ),
      ),
      body: Center(
        child: Container(
          width: width * 0.5,
          constraints: const BoxConstraints(
            minWidth: 320,
            maxWidth: 600,
          ),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Formulário de Usuário',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Campo Nome → ao pressionar Enter vai para Idade
                    TextFormField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      decoration: fieldDecoration('Nome'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(ageFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Campo Idade → ao pressionar Enter vai para Sexo
                    TextFormField(
                      controller: ageController,
                      focusNode: ageFocusNode,
                      decoration: fieldDecoration('Idade'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(genderFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Idade é obrigatória';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Digite apenas números';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Campo Sexo → ao receber foco abre o dropdown
                    Focus(
                      focusNode: genderFocusNode,
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                          // Pequeno delay para garantir que o widget esteja pronto
                          Future.delayed(Duration.zero, () {
                            genderFocusNode.unfocus();
                          });
                        }
                      },
                      child: DropdownSearch<String>(
                        items: (filter, _) {
                          if (filter.isEmpty) return genders;

                          return genders
                              .where(
                                (e) => e
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()),
                              )
                              .toList();
                        },
                        selectedItem: gender,
                        decoratorProps: DropDownDecoratorProps(
                          decoration: fieldDecoration('Sexo'),
                        ),
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: 'Pesquisar sexo',
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Sexo é obrigatório';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}