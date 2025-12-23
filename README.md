# 📊 Social Media Tracker v5 — ConectMe Uprise

## O FLUXO CORRETO

```
PRISCILA/MARCELA                      ALEC/VICTOR                         PAULA
(Social Media)                        (Gestores)                          (Supervisora)
      │                                    │                                   │
      ▼                                    │                                   │
   Cria post                               │                                   │
      │                                    │                                   │
      ▼                                    │                                   │
   Agenda no Ekyte                         │                                   │
   ou Meta Business                        │                                   │
      │                                    │                                   │
      ▼                                    │                                   │
   Informa no sistema:                     │                                   │
   - Plataforma (Ekyte/Meta)               │                                   │
   - Horário agendado                      │                                   │
   - Link do agendamento ──────────► Recebe alerta                            │
                                     "Verificar Agendamentos"                  │
                                           │                                   │
                                           ▼                                   │
                                     Vai no Ekyte/Meta                         │
                                     e confere:                                │
                                     • Horário correto?                        │
                                     • Identidade visual OK?                   │
                                     • Texto/legenda OK?                       │
                                     • Hashtags OK?                            │
                                           │                                   │
                                           ▼                                   │
                                     Marca checklist no sistema                │
                                     Status: "Tudo OK" ou "Problemas"          │
                                           │                                   │
                                           │                                   │
                              ═════════════════════════════                    │
                              NO DIA/HORA DA PUBLICAÇÃO                        │
                              ═════════════════════════════                    │
                                           │                                   │
                                           ▼                                   │
                                     Recebe alerta                             │
                                     "Verificar Instagram" ◄─────────────► Acompanha
                                           │                               tudo no
                                           ▼                               Dashboard
                                     Vai no Instagram                          │
                                     do cliente                                │
                                           │                                   │
                                           ▼                                   │
                                     Marca no sistema:                         │
                                     "Publicado OK" ou                         │
                                     "Problema"                                │
```

---

## ABAS DO SISTEMA

### 📈 Dashboard
- Alertas do que precisa fazer
- Números gerais (não agendados, agendados, verificados, concluídos)
- Lista de itens que precisam de atenção

### 🔍 Verificar Agendamentos
- Posts que estão agendados mas você ainda não verificou
- Você vai no Ekyte/Meta, confere, e marca:
  - 🕐 Horário OK
  - 🎨 Visual OK
  - 📝 Texto OK
  - # Hashtags OK
- Status: "Tudo OK" ou "Problemas"

### 📱 Verificar Instagram
- Posts que já deviam ter sido publicados
- Você vai no Instagram do cliente
- Marca: "Publicado OK" ou "Problema"

### 📋 Controle
- Tabela completa com todos os dados
- Filtros por gestor, social media, cliente, tipo, data

### 👥 Equipe
- Cards com progresso de cada membro

### ⚙️ Admin (só gestores)
- Cadastrar novos clientes

---

## PERMISSÕES

| Função | Pode fazer |
|--------|------------|
| **Social Media** | Informar plataforma, horário, link do agendamento |
| **Gestor** | Tudo acima + marcar verificações (pré e pós) |
| **Supervisora** | Tudo |

---

## QUEM VÊ O QUÊ

- **Alec**: Vê apenas clientes da Priscila
- **Victor**: Vê apenas clientes da Marcela
- **Paula**: Vê tudo

---

## INSTALAÇÃO

1. Execute o `setup-supabase.sql` no Supabase
2. Faça deploy no Vercel
3. Compartilhe o link
