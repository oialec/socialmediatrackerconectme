-- =============================================
-- SOCIAL MEDIA TRACKER v5 — ConectMe Uprise
-- FLUXO DE MONITORAMENTO
-- =============================================

DROP TABLE IF EXISTS daily_reviews CASCADE;
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
  role TEXT NOT NULL CHECK (role IN ('supervisor', 'gestor', 'social_media')),
  color TEXT DEFAULT '#a855f7',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO team_members (name, email, role, color) VALUES
  ('Paula', 'paula@conectme.digital', 'supervisor', '#ff6b6b'),
  ('Alec', 'alec@conectme.digital', 'gestor', '#a855f7'),
  ('Victor', 'victor@conectme.digital', 'gestor', '#22c55e'),
  ('Priscila', 'priscila@conectme.digital', 'social_media', '#3b82f6'),
  ('Marcela', 'marcela@conectme.digital', 'social_media', '#ec4899');

-- =============================================
-- CLIENTES
-- =============================================
CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  social_media TEXT, -- quem cria os posts
  gestor TEXT, -- quem monitora
  instagram_url TEXT, -- link do perfil do cliente
  color TEXT DEFAULT '#666666',
  active BOOLEAN DEFAULT TRUE,
  notes TEXT DEFAULT '',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clientes da Priscila (Alec monitora)
INSERT INTO clients (name, social_media, gestor, color) VALUES
  ('CDI', 'Priscila', 'Alec', '#ff6b6b'),
  ('Rosa Cali', 'Priscila', 'Alec', '#4ecdc4'),
  ('Talita Peixoto', 'Priscila', 'Alec', '#45b7d1'),
  ('Rose of Sharon', 'Priscila', 'Alec', '#96ceb4'),
  ('Toms Painters', 'Priscila', 'Alec', '#ffeaa7'),
  ('Terras Crystals', 'Priscila', 'Alec', '#dfe6e9'),
  ('Delicioso', 'Priscila', 'Alec', '#fd79a8'),
  ('Hunters', 'Priscila', 'Alec', '#a29bfe'),
  ('Thor Black Car', 'Priscila', 'Alec', '#6c5ce7'),
  ('Invisible Ink', 'Priscila', 'Alec', '#00b894'),
  ('Angela Dog', 'Priscila', 'Alec', '#e17055'),
  ('Sula Imports', 'Priscila', 'Alec', '#fdcb6e');

-- Clientes da Marcela (Victor monitora)
INSERT INTO clients (name, social_media, gestor, color) VALUES
  ('Sa Beauty', 'Marcela', 'Victor', '#74b9ff'),
  ('Wellness', 'Marcela', 'Victor', '#55efc4'),
  ('Edna', 'Marcela', 'Victor', '#81ecec'),
  ('Brasil Glow Medspa', 'Marcela', 'Victor', '#fab1a0'),
  ('Brazil Glow Dani', 'Marcela', 'Victor', '#ff7675'),
  ('Kris Borges', 'Marcela', 'Victor', '#a8e6cf'),
  ('Dra Juliana', 'Marcela', 'Victor', '#dcedc1'),
  ('Elite', 'Marcela', 'Victor', '#ffd3b6'),
  ('Glow-i', 'Marcela', 'Victor', '#ff8b94'),
  ('Chan Ramos', 'Marcela', 'Victor', '#91d8e4');

-- =============================================
-- ITENS (POSTS)
-- =============================================
CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
  client TEXT NOT NULL,
  social_media TEXT,
  gestor TEXT,
  type TEXT NOT NULL CHECK (type IN ('FEED', 'STORY')),
  date TEXT NOT NULL,
  content_type TEXT NOT NULL,
  is_checkpoint BOOLEAN DEFAULT FALSE,
  
  -- ========== AGENDAMENTO (Social Media preenche) ==========
  platform TEXT DEFAULT 'Não agendado' CHECK (platform IN ('Não agendado', 'Ekyte', 'Meta Business', 'Agendado direto')),
  scheduled_time TEXT, -- horário agendado (ex: "08:00")
  scheduling_link TEXT, -- link do agendamento no Ekyte/Meta para o gestor verificar
  
  -- ========== VERIFICAÇÃO PRÉ-PUBLICAÇÃO (Gestor verifica) ==========
  -- O gestor vai no Ekyte/Meta e confere se está tudo certo
  pre_check_status TEXT DEFAULT 'Não verificado' CHECK (pre_check_status IN ('Não verificado', 'Tudo OK', 'Problemas')),
  pre_check_time_ok BOOLEAN DEFAULT FALSE, -- horário correto?
  pre_check_visual_ok BOOLEAN DEFAULT FALSE, -- identidade visual OK?
  pre_check_text_ok BOOLEAN DEFAULT FALSE, -- texto/legenda OK?
  pre_check_hashtags_ok BOOLEAN DEFAULT FALSE, -- hashtags OK?
  pre_check_notes TEXT, -- observações/problemas encontrados
  pre_check_by TEXT,
  pre_check_at TIMESTAMP WITH TIME ZONE,
  
  -- ========== VERIFICAÇÃO PÓS-PUBLICAÇÃO (Gestor verifica) ==========
  -- No dia/hora, o gestor vai no Instagram do cliente e confere se publicou
  post_check_status TEXT DEFAULT 'Aguardando' CHECK (post_check_status IN ('Aguardando', 'Publicado OK', 'Não publicou', 'Publicou com erro')),
  instagram_post_link TEXT, -- link do post no Instagram (opcional)
  post_check_notes TEXT, -- observações
  post_check_by TEXT,
  post_check_at TIMESTAMP WITH TIME ZONE,
  
  -- ========== GERAL ==========
  observations TEXT DEFAULT '',
  last_updated_by TEXT,
  last_updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- POLÍTICAS E REALTIME
-- =============================================
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "full_access_items" ON items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "full_access_clients" ON clients FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "full_access_team" ON team_members FOR ALL USING (true) WITH CHECK (true);

ALTER PUBLICATION supabase_realtime ADD TABLE items;
ALTER PUBLICATION supabase_realtime ADD TABLE clients;

-- =============================================
-- ÍNDICES
-- =============================================
CREATE INDEX idx_items_date ON items(date);
CREATE INDEX idx_items_client ON items(client);
CREATE INDEX idx_items_gestor ON items(gestor);
CREATE INDEX idx_items_social_media ON items(social_media);
CREATE INDEX idx_items_pre_check ON items(pre_check_status);
CREATE INDEX idx_items_post_check ON items(post_check_status);

-- =============================================
-- FUNÇÃO PARA GERAR ITENS
-- =============================================
CREATE OR REPLACE FUNCTION generate_client_items(
  p_client_name TEXT,
  p_social_media TEXT,
  p_gestor TEXT
) RETURNS void AS $$
DECLARE
  feed_dates TEXT[] := ARRAY['22/12', '24/12', '26/12', '31/12', '02/01', '05/01'];
  story_dates TEXT[] := ARRAY['22/12', '23/12', '25/12', '26/12', '29/12', '30/12', '01/01', '02/01', '05/01'];
  d TEXT;
  content TEXT;
  is_check BOOLEAN;
  client_id_val INTEGER;
BEGIN
  SELECT id INTO client_id_val FROM clients WHERE name = p_client_name;
  
  FOREACH d IN ARRAY feed_dates LOOP
    content := 'Post Serviço';
    is_check := FALSE;
    IF d = '24/12' THEN content := 'Happy Holidays 🎄'; is_check := TRUE; END IF;
    IF d = '31/12' THEN content := 'Happy New Year 🎆'; is_check := TRUE; END IF;
    IF d = '02/01' THEN content := 'Primeira postagem do ano'; END IF;
    
    INSERT INTO items (client_id, client, social_media, gestor, type, date, content_type, is_checkpoint)
    VALUES (client_id_val, p_client_name, p_social_media, p_gestor, 'FEED', d, content, is_check);
  END LOOP;
  
  FOREACH d IN ARRAY story_dates LOOP
    content := 'Story';
    is_check := FALSE;
    IF d = '25/12' THEN content := 'Happy Holidays (diferente do feed) 🎄'; is_check := TRUE; END IF;
    IF d = '01/01' THEN content := 'Mensagem Motivacional ✨'; is_check := TRUE; END IF;
    
    INSERT INTO items (client_id, client, social_media, gestor, type, date, content_type, is_checkpoint)
    VALUES (client_id_val, p_client_name, p_social_media, p_gestor, 'STORY', d, content, is_check);
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- GERAR ITENS
-- =============================================
DO $$
DECLARE
  client_rec RECORD;
BEGIN
  FOR client_rec IN SELECT name, social_media, gestor FROM clients WHERE active = TRUE LOOP
    PERFORM generate_client_items(client_rec.name, client_rec.social_media, client_rec.gestor);
  END LOOP;
END $$;

-- =============================================
-- PENDÊNCIAS CONHECIDAS
-- =============================================
UPDATE items SET observations = '⚠️ Pendência identificada' 
WHERE client IN ('Sa Beauty', 'Wellness', 'Edna', 'Brasil Glow Medspa', 'Brazil Glow Dani', 'Kris Borges', 'Dra Juliana');
