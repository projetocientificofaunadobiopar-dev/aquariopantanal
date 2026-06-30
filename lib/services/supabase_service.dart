import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/especie.dart';

class SupabaseService {
  final SupabaseClient _sb = Supabase.instance.client;

  /// Lista pública: só espécies publicadas.
  Future<List<Especie>> listar() async {
    final res = await _sb
        .from('especies')
        .select()
        .eq('publicado', true)
        .order('nome_popular_pt', ascending: true);
    return (res as List)
        .map((m) => Especie.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  /// Lista admin: inclui rascunhos.
  Future<List<Especie>> listarTodas() async {
    final res = await _sb
        .from('especies')
        .select()
        .order('nome_popular_pt', ascending: true);
    return (res as List)
        .map((m) => Especie.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  Future<Especie> buscarPorId(String id) async {
    final res = await _sb.from('especies').select().eq('id', id).single();
    return Especie.fromMap(res);
  }

  Future<Especie> buscarPorSlug(String slug) async {
    final res =
        await _sb.from('especies').select().eq('slug', slug).single();
    return Especie.fromMap(res);
  }

  /// Busca por slug e, em caso de falha, tenta por id (fallback para URLs antigos).
  Future<Especie> buscarPorSlugOuId(String slugOrId) async {
    try {
      return await buscarPorSlug(slugOrId);
    } catch (_) {
      return await buscarPorId(slugOrId);
    }
  }

  Future<Especie> inserir(Especie e) async {
    final data = e.toMap()..remove('slug');
    final res =
        await _sb.from('especies').insert(data).select().single();
    return Especie.fromMap(res);
  }

  Future<Especie> atualizar(String id, Especie e) async {
    final data = e.toMap()..remove('slug');
    final res = await _sb
        .from('especies')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return Especie.fromMap(res);
  }

  Future<void> deletar(String id) async {
    await _sb.from('especies').delete().eq('id', id);
  }

  Future<String> uploadImagem({
    required Uint8List bytes,
    required String filename,
    String contentType = 'image/webp',
  }) async {
    final path =
        '${DateTime.now().millisecondsSinceEpoch}_$filename';
    await _sb.storage.from(SupabaseConfig.bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: false,
          ),
        );
    return _sb.storage.from(SupabaseConfig.bucket).getPublicUrl(path);
  }

  Future<void> login(String email, String password) async {
    await _sb.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() => _sb.auth.signOut();

  Session? get session => _sb.auth.currentSession;
  Stream<AuthState> get authChanges => _sb.auth.onAuthStateChange;
}
