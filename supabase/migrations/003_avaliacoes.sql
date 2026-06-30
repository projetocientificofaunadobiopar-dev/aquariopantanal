-- ============================================
-- Migração: tabela de avaliações de visitantes
-- Rodar no SQL Editor do Supabase
-- ============================================

create table if not exists public.avaliacoes (
  id uuid primary key default gen_random_uuid(),
  nota smallint not null check (nota between 1 and 5),
  comentario text,
  idioma text check (idioma in ('pt','en','es')),
  visitadas_count int,
  created_at timestamptz default now()
);

-- RLS: qualquer um (anon ou autenticado) pode INSERIR; só autenticado lê.
alter table public.avaliacoes enable row level security;

drop policy if exists "insert_publico_avaliacoes" on public.avaliacoes;
create policy "insert_publico_avaliacoes"
  on public.avaliacoes for insert
  to anon, authenticated
  with check (true);

drop policy if exists "select_autenticado_avaliacoes" on public.avaliacoes;
create policy "select_autenticado_avaliacoes"
  on public.avaliacoes for select
  to authenticated
  using (true);

comment on table public.avaliacoes is
  'Pesquisas de satisfação enviadas anonimamente por visitantes do app.';
