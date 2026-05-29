# Poupix — Contexto do Projeto

> Documento de referência para planejamento e implementação de melhorias.
> Gerado em: 2026-05-29 | Banco via MCP `user-poupix` (Supabase `fazvffsqjyqbxhxwvino`)

---

## 1. Visão geral

**Poupix** é um app Flutter de controle de despesas pessoais, em português (pt-BR), com backend Supabase. Versão atual: `1.0.0+9`.

**Propósito:** registrar, categorizar e visualizar gastos mensais com gráficos (donut por categoria, barras por tipo).

**Plataformas:** Android, iOS, Web (Flutter multi-plataforma).

**Autor:** Samir Pegado Gomes.

---

## 2. Stack técnica

| Camada | Tecnologia |
|--------|------------|
| UI | Flutter 3.6+, Material 3 |
| Estado global | `Provider` + `ChangeNotifier` (`AppState`, `AuthRepository`) |
| Navegação | `go_router` v16 |
| Backend | Supabase (Auth, Postgres, Storage, RPCs) |
| Cache local | `SharedPreferences` |
| Gráficos | `fl_chart` |
| Padrões | MVVM + Command/Result (Flutter team pattern) |

**Dependências notáveis:** `supabase_flutter`, `brasil_fields`, `pinput`, `image_picker`, `flutter_dotenv`, `shimmer`, `dropdown_button2`.

---

## 3. Arquitetura do app

```
lib/
├── main.dart              # Supabase init, MultiProvider, MaterialApp.router
├── environment.dart       # URL e anon key hardcoded (⚠️)
├── app_state/             # Cache local (usuário, despesas, categorias, mês selecionado)
├── data/
│   ├── repositories/      # Despesas, Categorias, Auth, Storage
│   └── services/          # AuthService (Edge Functions HTTP), CategoriaService
├── domain/models/         # Despesa, DespesasMes, Categorias, User, TotalCategoria/Tipo
├── routing/router.dart    # GoRouter com guards de auth
├── ui/                    # Telas por feature (auth, home, expenses, add, edit, categories, profile)
└── utils/                 # Command, Result, functions (formatadores, cores)
```

### Fluxo de inicialização

1. `main()` → Supabase.initialize → MultiProvider (AuthRepository, AppState)
2. Rota inicial: `/loading`
3. `LoadingViewModel.init()` → carrega SharedPreferences → busca `users` → busca categorias via RPC
4. Se `user.status == true` → `/home`; senão → `/verify` (OTP)

### Fluxo de dados (despesas)

1. ViewModels chamam `DespesasRepository.buscarDespesasMes()` → RPC `buscar_despesas_mes`
2. Resultado cacheado em `AppState.despesasMes` via SharedPreferences
3. Flag `overrideCache` controla refresh (limpa após insert/update/delete)
4. Mês selecionado persistido em `dataSelecionada`

### Navegação principal (BottomNavBar)

| Tab | Rota | Função |
|-----|------|--------|
| Home | `/home` | Dashboard com totais e gráficos |
| Despesas | `/expenses` | Lista filtrável por categoria |
| Adicionar | `/add` | Formulário nova despesa |
| Categorias | `/categories` | CRUD categorias |
| Perfil | `/profile` | Conta, foto, logout |

---

## 4. Banco de dados (Supabase — escopo Poupix)

> **Ignorar:** tabelas/funções com prefixo `flights_*` (outro projeto no mesmo banco).

### Tabelas principais

#### `users`
| Coluna | Tipo | Notas |
|--------|------|-------|
| id | uuid PK | FK → auth.users |
| email, nome, celular, cpf | text | Perfil |
| profile_pic | text | URL pública (bucket `profile`) |
| status | boolean | `false` = precisa verificar OTP; `true` = conta ativa |

**RLS:** CRUD apenas do próprio usuário (`auth.uid() = id`).

#### `categorias`
| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | identity |
| titulo | text | Nome da categoria |
| user_id | uuid FK | Dono; categorias padrão usam UUID fixo |

**Categorias padrão (system user):** `a67b0734-caeb-44ca-8390-457fbcd1c19d` (admin@poupix.com)
- Alimentação, Assinaturas e Serviços, Educação, Impostos e Taxas, Lazer, Outros, Pets, Presentes e Doações, Roupas, Saúde, Transporte

**RLS:** SELECT próprias + padrão; INSERT/UPDATE/DELETE apenas próprias.

#### `despesas`
| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | uuid | |
| categoria | bigint FK | |
| titulo, descricao | text | |
| valor | numeric | |
| tipo | text | `Única`, `Fixa`, `Parcelada` |
| vencimento | date | |
| parcelas, parcela_atual | smallint | Só tipo Parcelada |
| parcela_id | text | UUID agrupador de parcelas |
| liquidada | boolean | Default false — **sem UI no app** |

**Trigger:** `trg_gerar_parcelas_despesas_inline` (INSERT) → função `gerar_parcelas_despesas_inline()` cria parcelas 2..N automaticamente (+1 mês cada).

**RLS:** CRUD apenas do próprio usuário.

#### `email_otps`
OTP para verificação de conta e recovery. RLS habilitado **sem policies** (acesso via Edge Functions/service role).

#### `raw_events`
Log genérico JSONB (442 rows). RLS permissiva (`USING true`) — provável uso interno/analytics.

### Funções RPC (Poupix)

| Função | Uso no app |
|--------|------------|
| `buscar_despesas_mes(p_user_id, p_data, p_categoria?, p_liquidada?)` | Home + Expenses |
| `get_categorias(p_user_id)` | Loading + Categories |
| `gerar_parcelas_despesas_inline()` | Trigger (não chamada direta) |
| `cleanup_old_records()` | Cron — limpa raw_events > 1 dia |

#### Lógica `buscar_despesas_mes`
- **Parcelada:** filtra por mês/ano do `vencimento`
- **Fixa:** recorrente a partir do mês de vencimento original; `vencimento` ajustado ao mês consultado; `liquidada` por mês via tabela `despesas_fixas_liquidacao`
- **Única:** filtra por mês/ano do `vencimento`
- Agrega: `total`, `total_categoria[]`, `total_tipo[]`, `despesas[]`
- Parâmetros `p_categoria` e `p_liquidada` existem mas app passa string vazia (não usados)

### Storage

| Bucket | Público | Uso |
|--------|---------|-----|
| `assets` | sim | emptyUser.png, imagens estáticas |
| `profile` | sim | Fotos de perfil (`profile_{userId}.jpg`) |

### Edge Functions

**Deployadas atualmente (apenas flights — ignorar):**
- `daily-flight-search`
- `search-flights`

**Referenciadas no código mas NÃO deployadas:**
- `create-account`
- `send-otp`
- `verify-otp`
- `delete-account`
- `recover-password-mobile`
- `reset-password-mobile`

> ⚠️ **Gap crítico:** signup, verificação OTP, recovery e delete account dependem de Edge Functions ausentes no projeto Supabase.

---

## 5. Autenticação

| Fluxo | Implementação |
|-------|---------------|
| Login | `SupabaseAuthRepository` → `signInWithPassword` |
| Signup | `AuthService.createAccount` → Edge Function (ausente) |
| Verificação | OTP 4 dígitos via `send-otp` / `verify-otp` → seta `users.status = true` |
| Recovery | `recover-password-mobile` + `reset-password-mobile` |
| Change password | Tela existe (`/change-password`) |
| Delete account | `AuthService.deleteAccount` → Edge Function (ausente) |
| Logout | Supabase signOut + `AppState.logout()` (limpa cache) |

**Gate de acesso:** `/loading` redireciona para `/verify` se `status != true`.

**AuthService** usa `flutter_dotenv` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`), mas **`main.dart` não carrega dotenv** — credenciais duplicadas em `environment.dart`.

---

## 6. Features implementadas vs. gaps

### ✅ Implementado
- Login/logout
- Dashboard home (total mensal, gráfico donut categorias, barras tipos)
- Seletor de mês (MonthPicker)
- Lista de despesas com filtro por categoria
- CRUD despesas (add, edit, delete)
- Tipos: Única, Fixa, Parcelada (com geração automática de parcelas)
- CRUD categorias (add, edit, delete — padrão não editável)
- Perfil: foto, editar nome/celular, termos, donate (Buy me a coffee)
- Cache offline-first via SharedPreferences
- Locale pt-BR

### ❌ Não implementado / incompleto
- Marcar despesa como **liquidada** (campo existe no DB e model)
- Filtro por liquidada no RPC (param existe, UI não)
- Filtro por categoria no RPC (param existe, UI não)
- Receitas / entradas (só despesas)
- Orçamento / metas
- Notificações de vencimento
- Dark theme (ColorScheme definido, `themeMode: system` mas só light theme aplicado)
- Testes (widget_test.dart é boilerplate quebrado)
- Migrations/Edge Functions no repositório (sem pasta `supabase/`)
- Refresh pull-to-refresh
- Indicador visual de loading correto na Home (mostra EmptyState enquanto carrega)
- `CategoriaService.deletarPorId` existe mas CategoriesViewModel deleta direto (sem usar service/tratamento FK)
- Validação de parcelas mínimas no form
- Edição de despesas parceladas (edita só registro individual)

---

## 7. Problemas técnicos conhecidos

### Críticos
1. **Edge Functions de auth ausentes** — signup/verify/recovery/delete não funcionam em produção
2. **dotenv não inicializado** — `AuthService` vai falhar se `.env` não for carregado (main não chama `dotenv.load()`)
3. **Credenciais hardcoded** em `environment.dart` (anon key exposta no código)

### Segurança (Supabase Advisors)
- `get_categorias` SECURITY DEFINER executável por `anon` — pode vazar categorias de qualquer user_id
- `gerar_parcelas_despesas_inline` SECURITY DEFINER executável via RPC (deveria ser só trigger)
- `raw_events` RLS permissiva demais
- Buckets públicos permitem listagem de objetos
- `email_otps` sem policies
- Functions sem `search_path` fixo
- Leaked password protection desabilitado no Auth

### UX / bugs
- Home: loading state mostra `EmptyStateHome` em vez de spinner
- Expenses: `setState` duplicado no dropdown
- Despesas **Fixa** aparecem em todos os meses (comportamento do RPC)
- `StorageRepository`: checagem `if (updateResponse != null)` invertida (Postgrest retorna null em sucesso)
- Título do app: `'App'` em vez de `'Poupix'`
- Textos em inglês misturados ("Buy me a coffee", placeholders)
- Teste padrão não compila/não reflete o app

### Arquitetura
- ViewModels instanciados no router (sem Provider) — recriados a cada navegação
- Lógica Supabase espalhada entre ViewModels e widgets (ManageAccount, CategoryAdd)
- `despesaSelecionada` no AppState sem persistência (ok para fluxo edit)
- Sem camada de repository para despesas write (insert/update/delete direto nos ViewModels)

---

## 8. Modelo de domínio

### Tipos de despesa
| Tipo | Comportamento |
|------|---------------|
| Única | Aparece só no mês do vencimento |
| Fixa | Aparece em **todos** os meses |
| Parcelada | Uma linha por parcela; trigger gera N-1 registros; filtrada por mês |

### DespesasMesModel
```dart
{ total, despesas[], totalCategoria[{nome_categoria, valor}], totalTipo[{nome_tipo, valor}] }
```

---

## 9. Rotas completas

| Rota | Auth | Descrição |
|------|------|-----------|
| `/loading` | sim | Splash + bootstrap |
| `/login` | não | Login |
| `/signup` | não | Cadastro |
| `/verify` | sim | OTP verificação |
| `/home` | sim | Dashboard |
| `/expenses` | sim | Lista despesas |
| `/add` | sim | Nova despesa |
| `/edit` | sim | Editar despesa |
| `/categories` | sim | Categorias |
| `/profile` | sim | Perfil |
| `/change-password` | não* | Alterar senha |
| `/recovery` | não | Esqueci senha |
| `/new-password` | não | Nova senha (OTP) |
| `/donate` | não | Doação |
| `/policy` | não | Termos |

---

## 10. Backlog sugerido de melhorias

Organizado por prioridade para sessões futuras:

### P0 — Bloqueadores
- [x] Deploy/recriar Edge Functions de auth (create-account, send-otp, verify-otp, delete-account, recover/reset-password)
- [x] Unificar config Supabase (dotenv + remover hardcode)
- [x] Corrigir init dotenv no main.dart

### P1 — Core product
- [x] UI marcar despesa como liquidada (+ filtro liquidada/pendente)
- [x] Adicionar subtotais (liquidada/pendente/total)
- [x] Remover da NavBar o botão de add. 
- [x] Transformar as ações de Add/Edit/Delete em modais mais intuitivos
- [x] Remover a foto do perfil do usuário. Inserir um icone no lugar
- [x] Corrigir comportamento despesas Fixa (filtrar por mês ou renomear conceito)
- [x] Loading states corretos (Home, geral)
- [x] Tratamento de erro consistente (SnackBars, mensagens PT)

### P2 — UX/UI
- [x] Melhoria visual geral. Tornar o app mais intuitivo com cores mais adequadas ao modelo de app.
- [x] Pull-to-refresh nas listas
- [x] Localização completa PT-BR
- [x] Empty states informativos
- [x] Melhorias visuais login/profile (em andamento no git)

### P3 — Features novas (ideas)
- [x] Melhoria na exibição dos filtros de categoria e exibição. Modal com chips e opções aplicar/limpar.
- [x] Remover o botão de month picker da topbar e colocar perto do botão dos filtros.
- [x] Export PDF
- [x] Widget/resumo notificação (notificação local diária com resumo pendente; widget nativo fora do escopo)
- [ ] Busca global de despesas (removida por enquanto)

---

## 11. Comandos úteis

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```

**Supabase project:** `https://fazvffsqjyqbxhxwvino.supabase.co`

---

## 12. Notas para agentes IA

- Usar MCP `user-poupix` para alterações no banco
- Ignorar tabelas `flights_*` e edge functions de flights
- Seguir padrão MVVM + Command/Result existente
- Manter cache AppState + limparCacheDespesas após mutações
- UI em português
- Minimizar escopo por PR/melhoria
- Não commitar sem pedido explícito do usuário
