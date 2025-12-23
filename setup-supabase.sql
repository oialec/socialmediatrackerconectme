-- =============================================
-- SOCIAL MEDIA TRACKER - ConectMe Uprise
-- Execute este SQL no Supabase (SQL Editor)
-- =============================================

-- Limpar tabelas se existirem (para reinstalação limpa)
DROP TABLE IF EXISTS daily_reviews CASCADE;
DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS team_members CASCADE;

-- =============================================
-- TABELA DE MEMBROS DA EQUIPE
-- =============================================
CREATE TABLE team_members (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL CHECK (role IN ('gestor', 'social_media')),
  color TEXT DEFAULT '#bf5af2',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir membros da equipe
INSERT INTO team_members (name, email, role, color) VALUES
  ('Alec', 'alec@conectme.digital', 'gestor', '#bf5af2'),
  ('Paula', 'paula@conectme.digital', 'gestor', '#ff6b6b'),
  ('Victor', 'victor@conectme.digital', 'gestor', '#00b894'),
  ('Priscila', 'priscila@conectme.digital', 'social_media', '#64d2ff'),
  ('Marcela', 'marcela@conectme.digital', 'social_media', '#ff375f');

-- =============================================
-- TABELA DE CLIENTES
-- =============================================
CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  responsible TEXT, -- nome do social media responsável (pode ser null = sem responsável)
  color TEXT DEFAULT '#666666',
  active BOOLEAN DEFAULT TRUE,
  notes TEXT DEFAULT '',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clientes da Priscila
INSERT INTO clients (name, responsible, color) VALUES
  ('CDI', 'Priscila', '#ff6b6b'),
  ('Rosa Cali', 'Priscila', '#4ecdc4'),
  ('Talita Peixoto', 'Priscila', '#45b7d1'),
  ('Rose of Sharon', 'Priscila', '#96ceb4'),
  ('Toms Painters', 'Priscila', '#ffeaa7'),
  ('Terras Crystals', 'Priscila', '#dfe6e9'),
  ('Delicioso', 'Priscila', '#fd79a8'),
  ('Hunters', 'Priscila', '#a29bfe'),
  ('Thor Black Car', 'Priscila', '#6c5ce7'),
  ('Invisible Ink', 'Priscila', '#00b894'),
  ('Angela Dog', 'Priscila', '#e17055'),
  ('Sula Imports', 'Priscila', '#fdcb6e');

-- Clientes da Marcela
INSERT INTO clients (name, responsible, color) VALUES
  ('Sa Beauty', 'Marcela', '#74b9ff'),
  ('Wellness', 'Marcela', '#55efc4'),
  ('Edna', 'Marcela', '#81ecec'),
  ('Brasil Glow Medspa', 'Marcela', '#fab1a0'),
  ('Brazil Glow Dani', 'Marcela', '#ff7675'),
  ('Kris Borges', 'Marcela', '#a8e6cf'),
  ('Dra Juliana', 'Marcela', '#dcedc1'),
  ('Elite', 'Marcela', '#ffd3b6'),
  ('Glow-i', 'Marcela', '#ff8b94'),
  ('Chan Ramos', 'Marcela', '#91d8e4');

-- =============================================
-- TABELA DE ITENS (POSTS)
-- =============================================
CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
  client TEXT NOT NULL,
  responsible TEXT,
  type TEXT NOT NULL CHECK (type IN ('FEED', 'STORY')),
  date TEXT NOT NULL,
  content_type TEXT NOT NULL,
  is_checkpoint BOOLEAN DEFAULT FALSE,
  status_creation TEXT DEFAULT 'Pendente',
  status_approval TEXT DEFAULT 'Aguardando',
  status_schedule TEXT DEFAULT 'Não programado',
  observations TEXT DEFAULT '',
  material_link TEXT DEFAULT '',
  approved_by TEXT,
  approved_at TIMESTAMP WITH TIME ZONE,
  last_updated_by TEXT,
  last_updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- TABELA DE REVISÕES DIÁRIAS
-- =============================================
CREATE TABLE daily_reviews (
  id SERIAL PRIMARY KEY,
  review_date TEXT NOT NULL,
  reviewed_by TEXT NOT NULL,
  reviewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(review_date, reviewed_by)
);

-- =============================================
-- HABILITAR RLS E POLÍTICAS
-- =============================================
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Acesso total items" ON items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso total reviews" ON daily_reviews FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso total team" ON team_members FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso total clients" ON clients FOR ALL USING (true) WITH CHECK (true);

-- =============================================
-- HABILITAR REALTIME
-- =============================================
ALTER PUBLICATION supabase_realtime ADD TABLE items;
ALTER PUBLICATION supabase_realtime ADD TABLE daily_reviews;
ALTER PUBLICATION supabase_realtime ADD TABLE clients;

-- =============================================
-- ÍNDICES
-- =============================================
CREATE INDEX idx_items_date ON items(date);
CREATE INDEX idx_items_client ON items(client);
CREATE INDEX idx_items_responsible ON items(responsible);
CREATE INDEX idx_clients_responsible ON clients(responsible);

-- =============================================
-- FUNÇÃO PARA GERAR ITENS DE UM CLIENTE
-- =============================================
CREATE OR REPLACE FUNCTION generate_client_items(
  p_client_name TEXT,
  p_responsible TEXT
) RETURNS void AS $$
DECLARE
  feed_dates TEXT[] := ARRAY['22/12', '24/12', '26/12', '31/12', '02/01', '05/01'];
  story_dates TEXT[] := ARRAY['22/12', '23/12', '25/12', '26/12', '29/12', '30/12', '01/01', '02/01', '05/01'];
  d TEXT;
  content TEXT;
  is_check BOOLEAN;
  client_id_val INTEGER;
BEGIN
  -- Buscar ID do cliente
  SELECT id INTO client_id_val FROM clients WHERE name = p_client_name;
  
  -- Gerar FEEDS
  FOREACH d IN ARRAY feed_dates LOOP
    content := 'Post Serviço';
    is_check := FALSE;
    IF d = '24/12' THEN content := 'Happy Holidays 🎄'; is_check := TRUE; END IF;
    IF d = '31/12' THEN content := 'Happy New Year 🎆'; is_check := TRUE; END IF;
    IF d = '02/01' THEN content := 'Primeira postagem do ano'; END IF;
    
    INSERT INTO items (client_id, client, responsible, type, date, content_type, is_checkpoint)
    VALUES (client_id_val, p_client_name, p_responsible, 'FEED', d, content, is_check);
  END LOOP;
  
  -- Gerar STORIES
  FOREACH d IN ARRAY story_dates LOOP
    content := 'Story';
    is_check := FALSE;
    IF d = '25/12' THEN content := 'Happy Holidays (diferente do feed) 🎄'; is_check := TRUE; END IF;
    IF d = '01/01' THEN content := 'Mensagem Motivacional ✨'; is_check := TRUE; END IF;
    
    INSERT INTO items (client_id, client, responsible, type, date, content_type, is_checkpoint)
    VALUES (client_id_val, p_client_name, p_responsible, 'STORY', d, content, is_check);
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- GERAR ITENS PARA TODOS OS CLIENTES EXISTENTES
-- =============================================
DO $$
DECLARE
  client_rec RECORD;
BEGIN
  FOR client_rec IN SELECT name, responsible FROM clients WHERE active = TRUE LOOP
    PERFORM generate_client_items(client_rec.name, client_rec.responsible);
  END LOOP;
END $$;

-- =============================================
-- MARCAR PENDÊNCIAS CONHECIDAS DA MARCELA
-- =============================================
UPDATE items SET observations = '⚠️ Pendência identificada' 
WHERE client = 'Sa Beauty' AND date IN ('22/12', '29/12', '05/01') AND type = 'FEED';

UPDATE items SET observations = '⚠️ Pendência identificada' 
WHERE client = 'Wellness' AND date IN ('22/12', '24/12', '29/12', '05/01') AND type = 'FEED';

UPDATE items SET observations = '⚠️ Pendência identificada' 
WHERE client = 'Edna' AND date IN ('29/12', '05/01') AND type = 'FEED';

UPDATE items SET observations = '⚠️ Pendência identificada' 
WHERE client = 'Brasil Glow Medspa' AND date IN ('22/12', '24/12', '26/12', '31/12', '02/01', '05/01') AND type = 'FEED';

UPDATE items SET observations = '⚠️ Pendência identificada' 
WHERE client = 'Brazil Glow Dani' AND date IN ('24/12', '29/12', '05/01') AND type = 'FEED';

UPDATE items SET observations = '⚠️ Pendência identificada' 
WHERE client = 'Kris Borges' AND date IN ('22/12', '29/12', '05/01') AND type = 'FEED';

UPDATE items SET observations = '⚠️ Pendência identificada' 
WHERE client = 'Dra Juliana' AND date IN ('22/12', '24/12', '26/12', '29/12', '31/12', '02/01', '05/01') AND type = 'FEED';

-- =============================================
-- PRONTO! Banco configurado com sucesso.
-- =============================================
