import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:run_tracker_app_v2/model/run.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Run>> getRuns(String userId) async {
    final data = await supabase
        .from('runs')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List).map((e) => Run.fromJson(e)).toList();
  }

  Future<void> insertRun(Run run) async {
    await supabase.from('runs').insert(run.toJson());
  }

  Future<void> updateRun(String id, Run run) async {
    await supabase.from('runs').update(run.toJson()).eq('id', id);
  }

  Future<void> deleteRun(String id) async {
    await supabase.from('runs').delete().eq('id', id);
  }
}