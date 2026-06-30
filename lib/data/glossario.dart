/// Glossário trilíngue de termos técnicos comuns em fauna/conservação.
/// Para expandir: adicione um item à lista — sem precisar tocar em mais nada.
class TermoGlossario {
  final String termoPt;
  final String? termoEn;
  final String? termoEs;
  final String definicaoPt;
  final String definicaoEn;
  final String definicaoEs;

  const TermoGlossario({
    required this.termoPt,
    this.termoEn,
    this.termoEs,
    required this.definicaoPt,
    required this.definicaoEn,
    required this.definicaoEs,
  });
}

const List<TermoGlossario> kGlossario = [
  TermoGlossario(
    termoPt: 'Bioma',
    termoEn: 'Biome',
    termoEs: 'Bioma',
    definicaoPt:
        'Grande região ecológica com clima, vegetação e fauna característicos — como o Pantanal, a Amazônia ou o Cerrado.',
    definicaoEn:
        'A large ecological region with characteristic climate, vegetation and wildlife — such as the Pantanal, the Amazon or the Cerrado.',
    definicaoEs:
        'Una gran región ecológica con clima, vegetación y fauna característicos — como el Pantanal, la Amazonia o el Cerrado.',
  ),
  TermoGlossario(
    termoPt: 'Endêmico',
    termoEn: 'Endemic',
    termoEs: 'Endémico',
    definicaoPt:
        'Animal ou planta que só ocorre naturalmente em uma região específica do planeta. Se for extinto lá, some do mundo.',
    definicaoEn:
        'An animal or plant that only naturally occurs in a specific region of the planet. If it goes extinct there, it disappears worldwide.',
    definicaoEs:
        'Animal o planta que solo ocurre naturalmente en una región específica del planeta. Si se extingue allí, desaparece del mundo.',
  ),
  TermoGlossario(
    termoPt: 'Nicho ecológico',
    termoEn: 'Ecological niche',
    termoEs: 'Nicho ecológico',
    definicaoPt:
        'O "papel" que o animal cumpre no ecossistema: o que come, quem o come, como afeta os outros.',
    definicaoEn:
        'The "role" the animal plays in the ecosystem: what it eats, who eats it, how it affects others.',
    definicaoEs:
        'El "papel" que cumple el animal en el ecosistema: qué come, quién lo come, cómo afecta a otros.',
  ),
  TermoGlossario(
    termoPt: 'IUCN',
    definicaoPt:
        'União Internacional para Conservação da Natureza. Classifica espécies em categorias de risco (LC, NT, VU, EN, CR, EW, EX).',
    definicaoEn:
        'International Union for Conservation of Nature. Classifies species into risk categories (LC, NT, VU, EN, CR, EW, EX).',
    definicaoEs:
        'Unión Internacional para la Conservación de la Naturaleza. Clasifica especies en categorías de riesgo (LC, NT, VU, EN, CR, EW, EX).',
  ),
  TermoGlossario(
    termoPt: 'Neotenia',
    termoEn: 'Neoteny',
    termoEs: 'Neotenia',
    definicaoPt:
        'Quando o animal mantém características de filhote/larva mesmo depois de virar adulto. Famoso no axolote.',
    definicaoEn:
        'When the animal keeps juvenile/larval traits even after becoming an adult. Famous in the axolotl.',
    definicaoEs:
        'Cuando el animal mantiene rasgos juveniles/larvales aun siendo adulto. Famoso en el ajolote.',
  ),
  TermoGlossario(
    termoPt: 'Predador',
    termoEn: 'Predator',
    termoEs: 'Depredador',
    definicaoPt:
        'Animal que caça e come outros animais. Controla a população das presas e ajuda a equilibrar o ecossistema.',
    definicaoEn:
        'An animal that hunts and eats other animals. Controls prey populations and helps balance the ecosystem.',
    definicaoEs:
        'Animal que caza y come a otros animales. Controla las poblaciones de presas y ayuda a equilibrar el ecosistema.',
  ),
  TermoGlossario(
    termoPt: 'Presa',
    termoEn: 'Prey',
    termoEs: 'Presa',
    definicaoPt:
        'Animal que serve de alimento para outro animal (o predador).',
    definicaoEn: 'An animal that is food for another animal (the predator).',
    definicaoEs: 'Animal que sirve de alimento para otro animal (el depredador).',
  ),
  TermoGlossario(
    termoPt: 'Semiaquático',
    termoEn: 'Semi-aquatic',
    termoEs: 'Semiacuático',
    definicaoPt:
        'Vive tanto na água quanto na terra. Exemplos: jacaré, sucuri, capivara.',
    definicaoEn:
        'Lives both in water and on land. Examples: caiman, anaconda, capybara.',
    definicaoEs:
        'Vive tanto en el agua como en tierra. Ejemplos: yacaré, anaconda, carpincho.',
  ),
  TermoGlossario(
    termoPt: 'Regeneração',
    termoEn: 'Regeneration',
    termoEs: 'Regeneración',
    definicaoPt:
        'Capacidade de fazer crescer de novo partes do corpo perdidas, como patas ou caudas. O axolote é campeão nisso.',
    definicaoEn:
        'Ability to regrow lost body parts like limbs or tails. The axolotl is a champion at this.',
    definicaoEs:
        'Capacidad de hacer crecer de nuevo partes del cuerpo perdidas, como patas o colas. El ajolote es campeón en eso.',
  ),
  TermoGlossario(
    termoPt: 'Constritor',
    termoEn: 'Constrictor',
    termoEs: 'Constrictora',
    definicaoPt:
        'Serpente que mata a presa enrolando-se em volta dela e apertando até sufocá-la. Sucuris e jiboias são exemplos.',
    definicaoEn:
        'A snake that kills its prey by wrapping around it and squeezing until it suffocates. Anacondas and boas are examples.',
    definicaoEs:
        'Serpiente que mata a su presa enroscándose y apretándola hasta sofocarla. Anacondas y boas son ejemplos.',
  ),
  TermoGlossario(
    termoPt: 'Anfíbio',
    termoEn: 'Amphibian',
    termoEs: 'Anfibio',
    definicaoPt:
        'Vertebrado que nasce na água com brânquias e geralmente vira adulto na terra com pulmões. Sapos, rãs e salamandras.',
    definicaoEn:
        'A vertebrate born in water with gills, usually becoming a land adult with lungs. Toads, frogs and salamanders.',
    definicaoEs:
        'Vertebrado que nace en el agua con branquias y suele volverse adulto en tierra con pulmones. Sapos, ranas y salamandras.',
  ),
  TermoGlossario(
    termoPt: 'Bacia hidrográfica',
    termoEn: 'River basin',
    termoEs: 'Cuenca hidrográfica',
    definicaoPt:
        'Toda a região por onde a água da chuva escorre e se junta num mesmo rio principal. Ex.: bacia do Paraguai.',
    definicaoEn:
        'The whole region where rainwater drains and joins one main river. Ex.: Paraguay basin.',
    definicaoEs:
        'Toda la región por donde el agua de lluvia escurre y se une en un mismo río principal. Ej.: cuenca del Paraguay.',
  ),
  TermoGlossario(
    termoPt: 'Espécie ameaçada',
    termoEn: 'Threatened species',
    termoEs: 'Especie amenazada',
    definicaoPt:
        'Animal ou planta com risco real de desaparecer. Inclui categorias VU (vulnerável), EN (em perigo) e CR (criticamente em perigo).',
    definicaoEn:
        'An animal or plant facing real risk of disappearing. Includes VU (vulnerable), EN (endangered) and CR (critically endangered).',
    definicaoEs:
        'Animal o planta con riesgo real de desaparecer. Incluye VU (vulnerable), EN (en peligro) y CR (en peligro crítico).',
  ),
  TermoGlossario(
    termoPt: 'Pantanal',
    definicaoPt:
        'Maior planície alagável tropical do mundo, no centro da América do Sul. Patrimônio Natural da Humanidade pela UNESCO.',
    definicaoEn:
        "The world's largest tropical wetland, in central South America. A UNESCO World Heritage Site.",
    definicaoEs:
        'La mayor llanura inundable tropical del mundo, en el centro de Sudamérica. Patrimonio Natural de la Humanidad por la UNESCO.',
  ),
  TermoGlossario(
    termoPt: 'Vertebrado',
    termoEn: 'Vertebrate',
    termoEs: 'Vertebrado',
    definicaoPt:
        'Animal com coluna vertebral. Inclui peixes, anfíbios, répteis, aves e mamíferos.',
    definicaoEn:
        'An animal with a backbone. Includes fish, amphibians, reptiles, birds and mammals.',
    definicaoEs:
        'Animal con columna vertebral. Incluye peces, anfibios, reptiles, aves y mamíferos.',
  ),
];
