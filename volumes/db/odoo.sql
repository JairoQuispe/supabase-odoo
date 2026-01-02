\set pgpass `echo "$POSTGRES_PASSWORD"`

-- Crear schema dedicado para Odoo (sin RLS)
CREATE SCHEMA IF NOT EXISTS odoo;

-- Crear usuario específico para Odoo
CREATE USER odoo_user WITH PASSWORD :'pgpass';

-- Otorgar permisos completos al usuario odoo_user sobre el schema odoo
GRANT ALL ON SCHEMA odoo TO odoo_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA odoo TO odoo_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA odoo TO odoo_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA odoo GRANT ALL ON TABLES TO odoo_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA odoo GRANT ALL ON SEQUENCES TO odoo_user;

-- Crear usuario de solo lectura para Edge Functions
CREATE USER odoo_readonly WITH PASSWORD :'pgpass';
GRANT USAGE ON SCHEMA odoo TO odoo_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA odoo TO odoo_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA odoo GRANT SELECT ON TABLES TO odoo_readonly;

-- Permitir a supabase_admin acceder al schema odoo para Supabase Studio
GRANT USAGE ON SCHEMA odoo TO supabase_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA odoo TO supabase_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA odoo GRANT SELECT ON TABLES TO supabase_admin;

-- Deshabilitar RLS para el schema odoo (Odoo necesita acceso sin filtros)
ALTER SCHEMA odoo OWNER TO odoo_user;
