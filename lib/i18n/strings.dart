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
  String get sobreCreditos => _t(
        pt: 'Desenvolvido com ❤ para o Bioparque Pantanal',
        en: 'Built with ❤ for Pantanal Biopark',
        es: 'Desarrollado con ❤ para el Biopark Pantanal',
      );
}
