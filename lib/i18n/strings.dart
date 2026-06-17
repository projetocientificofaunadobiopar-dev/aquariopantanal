import '../providers/locale_provider.dart';

class Strings {
  final AppLocale loc;
  const Strings(this.loc);

  String _t({required String pt, required String en, required String es}) {
    switch (loc) {
      case AppLocale.pt:
        return pt;
      case AppLocale.en:
        return en;
      case AppLocale.es:
        return es;
    }
  }

  String get appTitle => _t(
        pt: 'Guia Bioparque Pantanal',
        en: 'Pantanal Biopark Guide',
        es: 'Guía Biopark Pantanal',
      );
  String get fauna =>
      _t(pt: 'Fauna', en: 'Fauna', es: 'Fauna');
  String get bioma => _t(
        pt: 'Bioma de origem',
        en: 'Biome of origin',
        es: 'Bioma de origen',
      );
  String get nicho => _t(
        pt: 'Nicho ecológico',
        en: 'Ecological niche',
        es: 'Nicho ecológico',
      );
  String get ouvir =>
      _t(pt: 'Ouvir', en: 'Listen', es: 'Escuchar');
  String get parar => _t(pt: 'Parar', en: 'Stop', es: 'Parar');
  String get voltar => _t(pt: 'Voltar', en: 'Back', es: 'Volver');
  String get login => _t(pt: 'Entrar', en: 'Login', es: 'Entrar');
  String get email => 'E-mail';
  String get senha =>
      _t(pt: 'Senha', en: 'Password', es: 'Contraseña');
  String get logout => _t(pt: 'Sair', en: 'Logout', es: 'Salir');
  String get admin => _t(
        pt: 'Painel Administrativo',
        en: 'Admin Panel',
        es: 'Panel de Administración',
      );
  String get novo => _t(
        pt: 'Nova espécie',
        en: 'New species',
        es: 'Nueva especie',
      );
  String get editar => _t(pt: 'Editar', en: 'Edit', es: 'Editar');
  String get excluir =>
      _t(pt: 'Excluir', en: 'Delete', es: 'Eliminar');
  String get salvar => _t(pt: 'Salvar', en: 'Save', es: 'Guardar');
  String get cancelar =>
      _t(pt: 'Cancelar', en: 'Cancel', es: 'Cancelar');
  String get nomeCientifico => _t(
        pt: 'Nome científico',
        en: 'Scientific name',
        es: 'Nombre científico',
      );
  String get nomePopular => _t(
        pt: 'Nome popular',
        en: 'Popular name',
        es: 'Nombre popular',
      );
  String get selecionarImagem => _t(
        pt: 'Selecionar imagem',
        en: 'Select image',
        es: 'Seleccionar imagen',
      );
  String get ajustarFoto => _t(
        pt: 'Ajustar foto',
        en: 'Adjust photo',
        es: 'Ajustar foto',
      );
  String get cropDica => _t(
        pt: 'Mova e ajuste a foto para enquadrar bem o animal',
        en: 'Move and adjust the photo to frame the animal well',
        es: 'Mueve y ajusta la foto para enmarcar bien al animal',
      );
  String get confirmar => _t(
        pt: 'Confirmar',
        en: 'Confirm',
        es: 'Confirmar',
      );
  String get carregando =>
      _t(pt: 'Carregando...', en: 'Loading...', es: 'Cargando...');
  String get nenhumaEspecie => _t(
        pt: 'Nenhuma espécie cadastrada ainda.',
        en: 'No species registered yet.',
        es: 'Ninguna especie registrada aún.',
      );
  String get confirmarExclusao => _t(
        pt: 'Confirmar exclusão?',
        en: 'Confirm deletion?',
        es: '¿Confirmar eliminación?',
      );
  String get erro => _t(pt: 'Erro', en: 'Error', es: 'Error');
  String get campoObrigatorio => _t(
        pt: 'Campo obrigatório',
        en: 'Required field',
        es: 'Campo obligatorio',
      );

  String get statusConservacao => _t(
        pt: 'Status de conservação',
        en: 'Conservation status',
        es: 'Estado de conservación',
      );
  String get classe => _t(pt: 'Classe', en: 'Class', es: 'Clase');
  String get familia =>
      _t(pt: 'Família', en: 'Family', es: 'Familia');
  String get tamanho =>
      _t(pt: 'Tamanho', en: 'Size', es: 'Tamaño');
  String get dieta => _t(pt: 'Dieta', en: 'Diet', es: 'Dieta');
  String get curiosidade => _t(
        pt: 'Você sabia?',
        en: 'Did you know?',
        es: '¿Sabías que?',
      );
  String get expectativaVida => _t(
        pt: 'Expectativa de vida',
        en: 'Lifespan',
        es: 'Esperanza de vida',
      );
  String get ameacas =>
      _t(pt: 'Ameaças', en: 'Threats', es: 'Amenazas');
  String get opcional =>
      _t(pt: '(opcional)', en: '(optional)', es: '(opcional)');
  String get selecione => _t(
        pt: 'Selecione...',
        en: 'Select...',
        es: 'Seleccione...',
      );
  String get buscar => _t(
        pt: 'Buscar espécies...',
        en: 'Search species...',
        es: 'Buscar especies...',
      );
  String get todos => _t(pt: 'Todos', en: 'All', es: 'Todos');
  String get descobrir => _t(
        pt: 'Descubra a fauna',
        en: 'Discover the fauna',
        es: 'Descubre la fauna',
      );
  String get descobrirSub => _t(
        pt: 'Um guia das espécies do Bioparque Pantanal',
        en: 'A guide to the species at Pantanal Biopark',
        es: 'Una guía de las especies del Biopark Pantanal',
      );
  // ===== Home (boas-vindas) =====
  String get welcomeOver => _t(
        pt: 'EDUCAÇÃO AMBIENTAL · BIOPARQUE PANTANAL',
        en: 'ENVIRONMENTAL EDUCATION · PANTANAL BIOPARK',
        es: 'EDUCACIÓN AMBIENTAL · BIOPARK PANTANAL',
      );
  String get welcomeTitle => _t(
        pt: 'Bem-vindo ao maior pantanal do mundo.',
        en: 'Welcome to the world\'s largest wetland.',
        es: 'Bienvenido al humedal más grande del mundo.',
      );
  String get welcomeSubtitle => _t(
        pt:
            'O Bioparque Pantanal é um centro de pesquisa e educação dedicado à fauna do Pantanal sul-mato-grossense. Conheça as espécies que dão vida a esse bioma único.',
        en:
            'Pantanal Biopark is a research and education center dedicated to the fauna of the Pantanal in Mato Grosso do Sul. Discover the species that give life to this unique biome.',
        es:
            'Biopark Pantanal es un centro de investigación y educación dedicado a la fauna del Pantanal de Mato Grosso do Sul. Descubre las especies que dan vida a este bioma único.',
      );
  String get acConhecerTitle => _t(
        pt: 'Conhecer a Fauna',
        en: 'Meet the Fauna',
        es: 'Conocer la Fauna',
      );
  String get acConhecerSub => _t(
        pt:
            'Mergulhe no catálogo completo de espécies. Aprenda sobre habitat, dieta, conservação e curiosidades de cada animal do Pantanal.',
        en:
            'Dive into the full species catalog. Learn about habitat, diet, conservation and curiosities of each Pantanal animal.',
        es:
            'Sumérgete en el catálogo completo de especies. Aprende sobre hábitat, dieta, conservación y curiosidades de cada animal del Pantanal.',
      );
  String get acConhecerCTA => _t(
        pt: 'Explorar espécies',
        en: 'Explore species',
        es: 'Explorar especies',
      );
  String get acScanTitle => _t(
        pt: 'Escanear QR Code',
        en: 'Scan QR Code',
        es: 'Escanear QR',
      );
  String get acScanSub => _t(
        pt:
            'Está visitando o aquário? Aponte o celular para os QR Codes em cada tanque e desbloqueie a história do animal à sua frente.',
        en:
            'Visiting the aquarium? Point your phone at the QR codes on each tank and unlock the story of the animal in front of you.',
        es:
            '¿Visitas el acuario? Apunta el celular a los QR de cada tanque y descubre la historia del animal frente a ti.',
      );
  String get acScanCTA => _t(
        pt: 'Abrir câmera',
        en: 'Open camera',
        es: 'Abrir cámara',
      );
  String get tituloFauna => _t(
        pt: 'Catálogo da fauna',
        en: 'Fauna catalog',
        es: 'Catálogo de fauna',
      );
  String get subtituloFauna => _t(
        pt: 'Cada espécie conta uma história do Pantanal.',
        en: 'Every species tells a Pantanal story.',
        es: 'Cada especie cuenta una historia del Pantanal.',
      );
  String get fauna2 =>
      _t(pt: 'Fauna', en: 'Fauna', es: 'Fauna');
  String get nenhumResultado => _t(
        pt: 'Nenhum resultado para este filtro',
        en: 'No results for this filter',
        es: 'Sin resultados para este filtro',
      );
  String get limparFiltros => _t(
        pt: 'Limpar filtros',
        en: 'Clear filters',
        es: 'Borrar filtros',
      );
  String get especies =>
      _t(pt: 'espécies', en: 'species', es: 'especies');
  String get traducaoPendente => _t(
        pt: 'Tradução pendente',
        en: 'Translation pending',
        es: 'Traducción pendiente',
      );
  String get traducaoPendenteDesc => _t(
        pt: 'Este conteúdo ainda está disponível só em português.',
        en: 'This content is currently only available in Portuguese.',
        es: 'Este contenido aún solo está disponible en portugués.',
      );
  String get semImagem =>
      _t(pt: 'Sem foto', en: 'No photo', es: 'Sin foto');
  String get semTraducao => _t(
        pt: 'Sem tradução',
        en: 'No translation',
        es: 'Sin traducción',
      );

  String get menu => _t(pt: 'Menu', en: 'Menu', es: 'Menú');
  String get inicio => _t(pt: 'Início', en: 'Home', es: 'Inicio');
  String get categorias =>
      _t(pt: 'Categorias', en: 'Categories', es: 'Categorías');
  String get sobre => _t(
        pt: 'Sobre o Bioparque',
        en: 'About the Biopark',
        es: 'Sobre el Biopark',
      );
  String get idioma =>
      _t(pt: 'Idioma', en: 'Language', es: 'Idioma');
  String get tema => _t(pt: 'Tema', en: 'Theme', es: 'Tema');
  String get temaClaro => _t(pt: 'Claro', en: 'Light', es: 'Claro');
  String get temaEscuro => _t(pt: 'Escuro', en: 'Dark', es: 'Oscuro');
  String get sistema =>
      _t(pt: 'Sistema', en: 'System', es: 'Sistema');
  String get areaRestrita => _t(
        pt: 'Área restrita',
        en: 'Staff area',
        es: 'Área restringida',
      );
  String get bioparqueDescricao => _t(
        pt:
            'O Bioparque Pantanal é o maior aquário de água doce do mundo, em Campo Grande/MS. Espaço dedicado à educação ambiental e à preservação da fauna do Pantanal.',
        en:
            'Pantanal Biopark is the world\'s largest freshwater aquarium, located in Campo Grande/MS, Brazil. A space dedicated to environmental education and Pantanal fauna preservation.',
        es:
            'El Biopark Pantanal es el acuario de agua dulce más grande del mundo, en Campo Grande/MS, Brasil. Dedicado a la educación ambiental y a la preservación de la fauna del Pantanal.',
      );
  String get tamanhoTexto =>
      _t(pt: 'Tamanho do texto', en: 'Text size', es: 'Tamaño del texto');
  String get acessibilidade => _t(
        pt: 'Acessibilidade',
        en: 'Accessibility',
        es: 'Accesibilidad',
      );
  String get instalarApp => _t(
        pt: 'Instalar o app',
        en: 'Install the app',
        es: 'Instalar la app',
      );
  String get instalarAppDesc => _t(
        pt: 'Adicione à tela inicial para acesso rápido, mesmo offline.',
        en: 'Add to your home screen for quick access, even offline.',
        es:
            'Añade a la pantalla de inicio para acceso rápido, incluso sin conexión.',
      );
  String get instalarIosTitulo => _t(
        pt: 'Adicionar à Tela de Início',
        en: 'Add to Home Screen',
        es: 'Añadir a la pantalla de inicio',
      );
  String get instalarIosInstr => _t(
        pt:
            '1. Toque no ícone de compartilhar abaixo\n2. Role e toque em "Adicionar à Tela de Início"\n3. Confirme em "Adicionar"',
        en:
            '1. Tap the share icon below\n2. Scroll and tap "Add to Home Screen"\n3. Confirm by tapping "Add"',
        es:
            '1. Toca el ícono compartir abajo\n2. Desplázate y toca "Añadir a pantalla de inicio"\n3. Confirma tocando "Añadir"',
      );
  String get entendi =>
      _t(pt: 'Entendi', en: 'Got it', es: 'Entendido');
  String get agoraNao =>
      _t(pt: 'Agora não', en: 'Not now', es: 'Ahora no');
  String get instalar =>
      _t(pt: 'Instalar', en: 'Install', es: 'Instalar');
  String get qrCode => _t(pt: 'QR Code', en: 'QR Code', es: 'QR Code');
  String get escanear =>
      _t(pt: 'Escanear QR', en: 'Scan QR', es: 'Escanear QR');
  String get scanInstrucao => _t(
        pt: 'Aponte a câmera para o QR do tanque',
        en: 'Point the camera at the tank\'s QR code',
        es: 'Apunta la cámara al QR del tanque',
      );
  String get camPermissaoNegada => _t(
        pt: 'Permissão de câmera negada',
        en: 'Camera permission denied',
        es: 'Permiso de cámara denegado',
      );
  String get camIndisponivel => _t(
        pt: 'Câmera indisponível neste dispositivo',
        en: 'Camera not available on this device',
        es: 'Cámara no disponible en este dispositivo',
      );
  String get qrNaoReconhecido => _t(
        pt: 'QR não reconhecido',
        en: 'QR not recognized',
        es: 'QR no reconocido',
      );
  String get alternarCamera => _t(
        pt: 'Alternar câmera',
        en: 'Switch camera',
        es: 'Cambiar cámara',
      );
  String get lanterna => _t(
        pt: 'Lanterna',
        en: 'Flashlight',
        es: 'Linterna',
      );
  String get baixarQr => _t(
        pt: 'Baixar QR',
        en: 'Download QR',
        es: 'Descargar QR',
      );
  String get copiarLink => _t(
        pt: 'Copiar link',
        en: 'Copy link',
        es: 'Copiar enlace',
      );
  String get linkCopiado => _t(
        pt: 'Link copiado!',
        en: 'Link copied!',
        es: '¡Enlace copiado!',
      );

  String get sobreCreditos => _t(
        pt: 'Desenvolvido com ❤ para o Bioparque Pantanal',
        en: 'Built with ❤ for Pantanal Biopark',
        es: 'Desarrollado con ❤ para el Biopark Pantanal',
      );
}
