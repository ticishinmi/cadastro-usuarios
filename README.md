# Cadastro de Usuários

Aplicação Flutter Web para cadastro, edição, exclusão e consulta de usuários. Os dados são mantidos em memória durante a sessão e não são persistidos após fechar o navegador.

---

## Tecnologias utilizadas

- **Flutter Web** — interface rodando no navegador (Chrome)
- **Dart** — linguagem principal

---

## Funcionalidades

- Listar usuários em ordem alfabética
- Cadastrar novo usuário (nome, idade e sexo)
- Editar usuário existente
- Excluir usuário com confirmação
- Filtrar usuários por nome em tempo real
- Navegação por teclado no formulário (Enter avança o campo, setas navegam no dropdown)
- Foco automático no primeiro campo inválido ao salvar

---

## Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Google Chrome](https://www.google.com/chrome/)
- [Git](https://git-scm.com/download/win)

---

## Instalação

**1. Clone o repositório:**
```bash
git clone https://github.com/ticishinmi/cadastro-usuarios.git
cd cadastro-usuarios
```

**2. Instale as dependências:**
```bash
flutter pub get
```

---

## Como rodar

```bash
flutter run -d chrome
```

O app abrirá automaticamente no navegador.

---

## Estrutura do projeto

```
cadastro-usuarios/
├── lib/
│   └── main.dart     # Interface Flutter Web
├── pubspec.yaml
└── README.md
```

---

## Observação

Os dados cadastrados ficam apenas em memória durante a sessão. Ao fechar ou recarregar o navegador os dados são perdidos.

---

## Autor

Desenvolvido por **ticishinmi**
