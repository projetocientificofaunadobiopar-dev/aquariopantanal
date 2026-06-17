# Guia Bioparque Pantanal — PWA

PWA bilíngue (PT/EN) com leitura por voz nativa (TTS) para guiar visitantes pela fauna do Bioparque Pantanal. Stack: **Flutter Web + Supabase + Vercel** (free tier).

## Estrutura

```
lib/
├── main.dart
├── config/supabase_config.dart
├── models/especie.dart
├── services/{supabase_service, tts_service}.dart
├── providers/{locale_provider, auth_provider}.dart
├── i18n/strings.dart
├── routes/app_router.dart
├── screens/
│   ├── home_screen.dart
│   ├── ficha_screen.dart
│   ├── login_screen.dart
│   └── admin/{admin_dashboard, especie_form}.dart
└── widgets/{especie_card, lang_switch}.dart
```

## 1. Configurar Supabase

1. Criar projeto em https://supabase.com (free tier).
2. SQL Editor → executar o script em `supabase/schema.sql`.
3. **Authentication → Users → Add user** → criar admin (ex. `admin@bioparque.ms`).
4. **Authentication → Providers → Email** → desabilitar "Confirm email" para login imediato.
5. Anotar **Project URL** e **anon key** em Settings → API.

## 2. Rodar localmente

```powershell
flutter pub get
flutter run -d chrome `
  --dart-define=SUPABASE_URL=https://SEU.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=eyJ...
```

Rotas:
- `/` — grade pública de espécies
- `/ficha/:id` — ficha técnica + botão Ouvir (TTS)
- `/login` — login da equipe
- `/admin` — CRUD (protegido)

## 3. Deploy no Vercel

1. Subir o repositório no GitHub.
2. Vercel → **Add New Project** → importar o repo.
3. **Framework Preset:** Other.
4. Em **Environment Variables**, adicionar:
   - `SUPABASE_URL` = URL do projeto
   - `SUPABASE_ANON_KEY` = anon key
5. Build/install command já vêm de `vercel.json` (instala Flutter stable e roda `flutter build web`).
6. Deploy. O `--pwa-strategy=offline-first` gera service worker para uso offline.

## 4. Otimizar imagens (free tier 1GB)

Antes de subir cada foto, converta para **WebP** ~800px, qualidade 80:

```powershell
cwebp -q 80 -resize 800 0 input.jpg -o saida.webp
```

Ou use https://squoosh.app/.

## Acessibilidade

O botão "Ouvir" usa `flutter_tts`, que aciona a voz nativa do dispositivo no idioma selecionado (`pt-BR` ou `en-US`). Não há arquivos de áudio armazenados.
