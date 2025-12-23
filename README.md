# 📊 Social Media Tracker v3.0 — ConectMe Uprise

Sistema completo de controle de postagens com login, permissões e sincronização em tempo real.

---

## 🚀 PASSO 1: Configurar o Supabase

1. Acesse seu projeto: https://supabase.com/dashboard
2. No menu lateral, clique em **SQL Editor**
3. Clique em **New Query**
4. Cole TODO o conteúdo do arquivo `setup-supabase.sql`
5. Clique em **Run**
6. Aguarde "Success"

---

## 🚀 PASSO 2: Deploy no Vercel

1. Acesse https://vercel.com/new
2. Arraste a pasta com `index.html` e `vercel.json`
3. Aguarde o deploy (30 segundos)
4. Pronto! Compartilhe o link com a equipe

---

## 👥 Usuários Cadastrados

| Nome     | E-mail                    | Função       |
|----------|---------------------------|--------------|
| Alec     | alec@conectme.digital     | Gestor       |
| Paula    | paula@conectme.digital    | Gestor       |
| Victor   | victor@conectme.digital   | Gestor       |
| Priscila | priscila@conectme.digital | Social Media |
| Marcela  | marcela@conectme.digital  | Social Media |

---

## 🔐 Permissões

### Gestores podem:
- ✅ Aprovar conteúdos
- ✅ Marcar dias como "Revisado"
- ✅ Cadastrar novos clientes
- ✅ Excluir clientes
- ✅ Todas as outras ações

### Social Media pode:
- ✅ Marcar status de Criação (Pendente → Em andamento → Criado)
- ✅ Marcar como Programado/Publicado
- ✅ Adicionar links e observações
- ❌ NÃO pode aprovar (campo desabilitado)
- ❌ NÃO pode marcar dia como revisado

---

## ✨ Funcionalidades

### 🔄 Sincronização em Tempo Real
Quando alguém atualiza algo, aparece instantaneamente para todos.

### 📊 Dashboard Visual
- Números gigantes para ver status de longe
- Barra de progresso colorida
- Cards de progresso por responsável
- Lista de itens urgentes (atrasados piscando em vermelho)

### ⚡ Filtros Rápidos
- 🚨 **Atrasados**: Itens com data passada
- 📅 **Hoje**: O que precisa sair hoje
- ⭐ **Checkpoints**: Datas especiais (24, 25, 31/12 e 01/01)
- ⏳ **Pendentes**: Tudo que ainda não começou

### ✅ Ações em Lote
Selecione vários itens e marque todos de uma vez.

### ⚙️ Painel Admin (só gestores)
- Cadastrar novos clientes
- Atribuir responsável
- Escolher cor do cliente
- Excluir clientes

---

## 📅 Calendário de Postagens

### FEED (6 posts por cliente)
- 22/12 — Post Serviço
- 24/12 — **Happy Holidays** ⭐
- 26/12 — Post Serviço
- 31/12 — **Happy New Year** ⭐
- 02/01 — Primeira postagem do ano
- 05/01 — Post Serviço

### STORY (9 stories por cliente)
- 22, 23, 25, 26, 29, 30/12
- 01, 02, 05/01

---

## ⚠️ Regra de Ouro

Nenhuma postagem pode ficar sem status após 22/12!

O post de **05/01 deve estar programado ANTES da virada do ano**.

---

## 🆘 Problemas Comuns

**"Carregando..." infinito**
→ Execute o SQL no Supabase primeiro

**E-mail não encontrado**
→ Verifique se digitou corretamente (incluindo @conectme.digital)

**Não consigo aprovar**
→ Apenas gestores podem aprovar. Faça login com conta de gestor.

**Clientes não aparecem após cadastrar**
→ Aguarde alguns segundos, a sincronização é automática

---

## 📞 Suporte

Desenvolvido por Claude para ConectMe Uprise
