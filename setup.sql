-- =============================================
-- CONECTME TRACKER v7
-- Sistema de Monitoramento de Posts
-- =============================================

DROP TABLE IF EXISTS activity_log CASCADE;
DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS team_members CASCADE;

-- =============================================
-- EQUIPE
-- =============================================
CREATE TABLE team_members (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL CHECK (role IN ('paula', 'gestor', 'social_media')),
  manages TEXT,
  color TEXT DEFAULT '#6366f1',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO team_members (name, email, role, manages, color) VALUES
  ('Paula', 'paula@conectme.digital', 'paula', NULL, '#ec4899'),
  ('Alec', 'alec@conectme.digital', 'gestor', 'Priscila', '#6366f1'),
  ('Victor', 'victor@conectme.digital', 'gestor', 'Marcela', '#10b981'),
  ('Priscila', 'priscila@conectme.digital', 'social_media', NULL, '#3b82f6'),
  ('Marcela', 'marcela@conectme.digital', 'social_media', NULL, '#f59e0b');

-- =============================================
-- CLIENTES
-- =============================================
CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  social_media TEXT NOT NULL,
  gestor TEXT NOT NULL,
  instagram TEXT,
  color TEXT DEFAULT '#64748b',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clientes da Priscila (Alec monitora)
INSERT INTO clients (name, social_media, gestor, color) VALUES
  ('CDI', 'Priscila', 'Alec', '#ef4444'),
  ('Rosa Cali', 'Priscila', 'Alec', '#f97316'),
  ('Talita Peixoto', 'Priscila', 'Alec', '#eab308'),
  ('Rose of Sharon', 'Priscila', 'Alec', '#84cc16'),
  ('Toms Painters', 'Priscila', 'Alec', '#22c55e'),
  ('Terras Crystals', 'Priscila', 'Alec', '#14b8a6'),
  ('Delicioso', 'Priscila', 'Alec', '#06b6d4'),
  ('Hunters', 'Priscila', 'Alec', '#0ea5e9'),
  ('Thor Black Car', 'Priscila', 'Alec', '#3b82f6'),
  ('Invisible Ink', 'Priscila', 'Alec', '#6366f1'),
  ('Angela Dog', 'Priscila', 'Alec', '#8b5cf6'),
  ('Sula Imports', 'Priscila', 'Alec', '#a855f7');

-- Clientes da Marcela (Victor monitora)
INSERT INTO clients (name, social_media, gestor, color) VALUES
  ('Sa Beauty', 'Marcela', 'Victor', '#d946ef'),
  ('Wellness', 'Marcela', 'Victor', '#ec4899'),
  ('Edna', 'Marcela', 'Victor', '#f43f5e'),
  ('Brasil Glow Medspa', 'Marcela', 'Victor', '#fb7185'),
  ('Brazil Glow Dani', 'Marcela', 'Victor', '#fda4af'),
  ('Kris Borges', 'Marcela', 'Victor', '#fbbf24'),
  ('Dra Juliana', 'Marcela', 'Victor', '#a3e635'),
  ('Elite', 'Marcela', 'Victor', '#4ade80'),
  ('Glow-i', 'Marcela', 'Victor', '#2dd4bf'),
  ('Chan Ramos', 'Marcela', 'Victor', '#38bdf8');

-- =============================================
-- POSTS
-- =============================================
CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  client TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('FEED', 'STORY')),
  description TEXT NOT NULL,
  is_special BOOLEAN DEFAULT FALSE,
  social_media TEXT NOT NULL,
  gestor TEXT NOT NULL,
  scheduled_date TEXT NOT NULL,
  scheduled_time TEXT,
  platform TEXT CHECK (platform IN ('ekyte', 'meta', 'direto')),
  
  status TEXT DEFAULT 'pendente' CHECK (status IN (
    'pendente',
    'nao_agendou',
    'agendado',
    'verificar_ig',
    'publicado',
    'problema'
  )),
  
  check_horario BOOLEAN DEFAULT FALSE,
  check_visual BOOLEAN DEFAULT FALSE,
  check_texto BOOLEAN DEFAULT FALSE,
  
  problema_descricao TEXT,
  problema_resolvido BOOLEAN DEFAULT FALSE,
  observacoes TEXT,
  
  verificado_por TEXT,
  verificado_em TIMESTAMP WITH TIME ZONE,
  publicado_por TEXT,
  publicado_em TIMESTAMP WITH TIME ZONE,
  
  updated_by TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- LOG DE ATIVIDADES
-- =============================================
CREATE TABLE activity_log (
  id SERIAL PRIMARY KEY,
  item_id INTEGER REFERENCES items(id),
  client TEXT,
  type TEXT,
  action TEXT NOT NULL,
  details TEXT,
  user_name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- GERAR POSTS
-- =============================================
DO $$
DECLARE
  c RECORD;
BEGIN
  FOR c IN SELECT name, social_media, gestor FROM clients LOOP
    INSERT INTO items (client, type, description, is_special, social_media, gestor, scheduled_date) VALUES
      (c.name, 'FEED', 'Post Serviço', FALSE, c.social_media, c.gestor, '22/12'),
      (c.name, 'FEED', 'Happy Holidays 🎄', TRUE, c.social_media, c.gestor, '24/12'),
      (c.name, 'FEED', 'Post Serviço', FALSE, c.social_media, c.gestor, '26/12'),
      (c.name, 'FEED', 'Happy New Year 🎆', TRUE, c.social_media, c.gestor, '31/12'),
      (c.name, 'FEED', 'Primeira postagem do ano', FALSE, c.social_media, c.gestor, '02/01'),
      (c.name, 'FEED', 'Post Serviço', FALSE, c.social_media, c.gestor, '05/01');
    
    INSERT INTO items (client, type, description, is_special, social_media, gestor, scheduled_date) VALUES
      (c.name, 'STORY', 'Story', FALSE, c.social_media, c.gestor, '22/12'),
      (c.name, 'STORY', 'Story', FALSE, c.social_media, c.gestor, '23/12'),
      (c.name, 'STORY', 'Happy Holidays 🎄', TRUE, c.social_media, c.gestor, '25/12'),
      (c.name, 'STORY', 'Story', FALSE, c.social_media, c.gestor, '26/12'),
      (c.name, 'STORY', 'Story', FALSE, c.social_media, c.gestor, '29/12'),
      (c.name, 'STORY', 'Story', FALSE, c.social_media, c.gestor, '30/12'),
      (c.name, 'STORY', 'Mensagem Motivacional ✨', TRUE, c.social_media, c.gestor, '01/01'),
      (c.name, 'STORY', 'Story', FALSE, c.social_media, c.gestor, '02/01'),
      (c.name, 'STORY', 'Story', FALSE, c.social_media, c.gestor, '05/01');
  END LOOP;
END $$;

-- =============================================
-- POLÍTICAS
-- =============================================
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all_items" ON items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "all_clients" ON clients FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "all_team" ON team_members FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "all_log" ON activity_log FOR ALL USING (true) WITH CHECK (true);

ALTER PUBLICATION supabase_realtime ADD TABLE items;
ALTER PUBLICATION supabase_realtime ADD TABLE clients;
ALTER PUBLICATION supabase_realtime ADD TABLE activity_log;

CREATE INDEX idx_items_status ON items(status);
CREATE INDEX idx_items_client ON items(client);
CREATE INDEX idx_items_gestor ON items(gestor);
CREATE INDEX idx_items_date ON items(scheduled_date);
