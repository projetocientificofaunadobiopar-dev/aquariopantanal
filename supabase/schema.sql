-- ============================================
-- Bioparque Pantanal - Schema Supabase
-- Executar no SQL Editor do projeto Supabase
-- ============================================

-- ===== TABELA ESPECIES =====
create table if not exists public.especies (
  id uuid primary key default gen_random_uuid(),
  nome_popular_pt text not null,
  nome_popular_en text not null,
  nome_cientifico text not null,
  bioma_origem_pt text not null,
  bioma_origem_en text not null,
  nicho_ecologico_pt text not null,
  nicho_ecologico_en text not null,
  imagem_url text,
  imagens text[] not null default '{}',
  status_conservacao text check (status_conservacao is null or status_conservacao in
    ('LC','NT','VU','EN','CR','EW','EX','DD')),
  classe text check (classe is null or classe in
    ('mamifero','reptil','anfibio','peixe','ave','invertebrado')),
  familia text,
  tamanho_pt text,
  tamanho_en text,
  dieta_pt text,
  dieta_en text,
  curiosidade_pt text,
  curiosidade_en text,
  expectativa_vida_pt text,
  expectativa_vida_en text,
  ameacas_pt text,
  ameacas_en text,
  nome_popular_es text,
  bioma_origem_es text,
  nicho_ecologico_es text,
  tamanho_es text,
  dieta_es text,
  curiosidade_es text,
  expectativa_vida_es text,
  ameacas_es text,
  slug text unique,
  setor text,
  tanque text,
  publicado boolean not null default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists idx_especies_nome_pt
  on public.especies (nome_popular_pt);
create index if not exists idx_especies_publicado
  on public.especies (publicado);

-- ===== TRIGGER updated_at =====
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end; $$;

drop trigger if exists trg_especies_updated on public.especies;
create trigger trg_especies_updated
before update on public.especies
for each row execute function public.set_updated_at();

-- ===== RLS =====
alter table public.especies enable row level security;

drop policy if exists "leitura_publica_especies" on public.especies;
create policy "leitura_publica_especies"
  on public.especies for select
  to anon, authenticated using (true);

drop policy if exists "insert_autenticado_especies" on public.especies;
create policy "insert_autenticado_especies"
  on public.especies for insert
  to authenticated with check (true);

drop policy if exists "update_autenticado_especies" on public.especies;
create policy "update_autenticado_especies"
  on public.especies for update
  to authenticated using (true) with check (true);

drop policy if exists "delete_autenticado_especies" on public.especies;
create policy "delete_autenticado_especies"
  on public.especies for delete
  to authenticated using (true);

-- ===== STORAGE BUCKET =====
insert into storage.buckets (id, name, public)
values ('especies-img', 'especies-img', true)
on conflict (id) do nothing;

drop policy if exists "leitura_publica_imagens" on storage.objects;
create policy "leitura_publica_imagens"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'especies-img');

drop policy if exists "upload_autenticado_imagens" on storage.objects;
create policy "upload_autenticado_imagens"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'especies-img');

drop policy if exists "update_autenticado_imagens" on storage.objects;
create policy "update_autenticado_imagens"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'especies-img');

drop policy if exists "delete_autenticado_imagens" on storage.objects;
create policy "delete_autenticado_imagens"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'especies-img');
