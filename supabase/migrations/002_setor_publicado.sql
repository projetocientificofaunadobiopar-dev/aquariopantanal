-- ============================================
-- Migração: localização (setor/tanque) + draft/publicado
-- Rodar no SQL Editor do Supabase
-- ============================================

alter table public.especies
  add column if not exists setor text,
  add column if not exists tanque text,
  add column if not exists publicado boolean not null default true;

create index if not exists idx_especies_publicado
  on public.especies (publicado);

comment on column public.especies.setor is
  'Setor onde encontrar a espécie no Bioparque (ex.: A, B, C).';
comment on column public.especies.tanque is
  'Identificador do aquário/recinto onde está exposta (ex.: 3, A2).';
comment on column public.especies.publicado is
  'Se false, espécie em rascunho — não aparece para visitantes.';
