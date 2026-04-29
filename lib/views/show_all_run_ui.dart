import 'package:flutter/material.dart';
import 'package:run_tracker_app_v2/views/add_run_ui.dart';
import 'package:run_tracker_app_v2/views/update_delete_run_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShowAllRunUi extends StatefulWidget {
  const ShowAllRunUi({super.key});

  @override
  State<ShowAllRunUi> createState() => _ShowAllRunUiState();
}

class _ShowAllRunUiState extends State<ShowAllRunUi> {
  List<Map<String, dynamic>> runs = []; //เก็บข้อมูลที่ได้จาก Supabase
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRuns();
  }

  Future<void> loadRuns() async {
    final user = Supabase.instance.client.auth.currentUser; //เช็ค user

    if(user == null) {
      //ยังไม่ login
      setState(() => isLoading = false);
      return;
    }

    try{
      final data = await Supabase.instance.client
          .from('runs')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        //เอาข้อมูลมาเก็บ runs
        runs = List<Map<String, dynamic>>.from(data);
      });
    }catch (e) {
      //ถ้ามี error ให้แสดงข้อความ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'โหลดข้อมูลผิดพลาด: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }finally {
      //โหลดเสร็จปิด loading
      setState(() => isLoading = false);
    }
  }

//------------------ลบข้อมูล
  Future<void> deleteRun(String id) async {
    try{
      await Supabase.instance.client.from('runs').delete().eq('id', id);
      await loadRuns();
      if(!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ลบสำเร็จ',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ลบไม่สำเร็จ: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

//------------------ Function ถามก่อนลบ
  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'ยืนยันการลบ',
          ),
          content: const Text(
            'คุณต้องการลบข้อมูลนี้ใช่ไหม?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'ยกเลิก',
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteRun(id);
              },
              child: const Text(
                'ลบ',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF090359),
        title: const Text(
          'Run Tracker V2',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) //กําลังโหลด
          : user == null
              ? const Center(
                  child: Text(
                    'กรุณา login ก่อน',
                  ),
                )
              : runs.isEmpty
                  ? const Center(
                      child: Text(
                        'ไม่มีข้อมูล',
                      ),
                    )
                  : ListView.builder(
                      itemCount: runs.length,
                      itemBuilder: (context, index) {
                        final run = runs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          child: ListTile(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UpdateDeleteRunUi(run: run), //ส่งข้อมูล **ต้องไปเพิ่มหน้าตัวแปรหน้า update
                                ),
                              );
                              if(result == true) {
                                loadRuns();
                              }
                            },
                            leading: const Icon(Icons.directions_run),
                            title: Text(
                              'สถานที่: ${run['location']}',
                            ),
                            subtitle: Text(
                              'ระยะทาง: ${run['distance']} km | คน: ${run['participants']}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                confirmDelete(run['id']);
                              },
                            ),
                            tileColor: index.isEven
                                ? Colors.blue[50]
                                : Colors.blue[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF090359),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRunUi()),
          );

          if (result == true) {
            loadRuns();
          }
        },
      ),
    );
  }
}
