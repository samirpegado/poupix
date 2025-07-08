import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';

class Policy extends StatefulWidget {
  const Policy({super.key});

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Termos e Política',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        leading: IconButton(
          onPressed: () => context.go('/signup'),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.black1,
      ),
      body: Padding(
        padding: Dimens.of(context).edgeInsetsScreen,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Termos de Uso e Política de Privacidade',
                  style: AppTheme.lightTheme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Text('''Aplicativo: Poupix
Última atualização: 10/07/2025

📌 Sobre o aplicativo
O Poupix é um aplicativo gratuito voltado exclusivamente para o registro e acompanhamento de despesas pessoais. Seu objetivo é ajudar o usuário a ter mais controle sobre seus gastos de maneira simples e prática.

✅ Termos de Uso

1. Aceitação
Ao utilizar o Poupix, você concorda com estes Termos de Uso e com a Política de Privacidade abaixo. Se não concordar, não utilize o aplicativo.

2. Funcionalidade
O app permite que o usuário registre despesas, categorize gastos e visualize relatórios simples. O funcionamento pode ser alterado ou descontinuado a qualquer momento, sem aviso prévio.

3. Gratuidade
O Poupix é completamente gratuito, sem compras internas ou cobrança por funcionalidades.

4. Responsabilidade
O uso do app é de responsabilidade exclusiva do usuário. O desenvolvedor não se responsabiliza por perdas financeiras, dados corrompidos ou mal uso da ferramenta.

🔒 Política de Privacidade

1. Coleta de dados
O Poupix não coleta nem compartilha informações pessoais sensíveis. Todos os dados inseridos (como nome da despesa, categoria, valor e data) são utilizados exclusivamente para a funcionalidade do app e pertencem ao próprio usuário.

2. Armazenamento de dados
Os dados podem ser armazenados localmente no dispositivo ou, se aplicável, em serviços de autenticação utilizados pelo usuário. O Poupix não envia dados a servidores de terceiros para fins comerciais ou analíticos.

3. Compartilhamento de dados
O Poupix não compartilha nenhuma informação do usuário com terceiros.

4. Permissões
O app pode solicitar permissões básicas, como acesso ao armazenamento local, apenas para garantir o funcionamento de recursos como salvar dados ou exportar informações.

📫 Contato

Para dúvidas, sugestões ou solicitações relacionadas à privacidade, entre em contato pelo e-mail:
contato@sognolabs.org''')
            ],
          ),
        ),
      ),
    );
  }
}
