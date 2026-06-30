-- ============================================
-- Migração: adiciona galeria de fotos por espécie
-- Rodar no SQL Editor do Supabase
-- ============================================

alter table public.especies
  add column if not exists imagens text[] not null default '{}';

comment on column public.especies.imagem_url is
  'Foto capa (mostrada nos cards). Também é a primeira da galeria.';
comment on column public.especies.imagens is
  'URLs das fotos ADICIONAIS da galeria (exclui a capa imagem_url).';
