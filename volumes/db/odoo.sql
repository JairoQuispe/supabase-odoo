\set pgpass `echo "$POSTGRES_PASSWORD"`

-- =============================================================================
-- CONFIGURACIÓN COMPLETA PARA ODOO EN SCHEMA PUBLIC + SUPABASE EN SCHEMA APP
-- =============================================================================

-- Crear usuario específico para Odoo (privilegios completos en public)
CREATE USER odoo_user WITH PASSWORD :'pgpass';

-- Otorgar permisos COMPLETOS e IDÉNTICOS a odoo_user sobre el schema public
-- (Mismos privilegios que supabase_admin tiene sobre el schema app)
GRANT ALL ON SCHEMA public TO odoo_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO odoo_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO odoo_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO odoo_user;
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA public TO odoo_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO odoo_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO odoo_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO odoo_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON PROCEDURES TO odoo_user;

-- Crear schema app para Supabase (aplicaciones web)
CREATE SCHEMA IF NOT EXISTS app;

-- Otorgar permisos completos a supabase_admin sobre el schema app
GRANT ALL ON SCHEMA app TO supabase_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA app TO supabase_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA app TO supabase_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT ALL ON TABLES TO supabase_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT ALL ON SEQUENCES TO supabase_admin;

-- Permitir acceso cruzado controlado entre schemas
GRANT USAGE ON SCHEMA public TO supabase_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO supabase_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO supabase_admin;

-- Configurar search_path por defecto para cada usuario
ALTER USER odoo_user SET search_path = public;
ALTER USER supabase_admin SET search_path = app, public;

-- Deshabilitar RLS para el schema public (Odoo necesita acceso sin filtros)
ALTER SCHEMA public OWNER TO odoo_user;
