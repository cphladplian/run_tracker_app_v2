import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateDeleteRunUi extends StatefulWidget {
  final Map<String, dynamic> run;

  const UpdateDeleteRunUi({super.key, required this.run});

  @override
  State<UpdateDeleteRunUi> createState() => _UpdateDeleteRunUiState();
}

class _UpdateDeleteRunUiState extends State<UpdateDeleteRunUi> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    locationController.text = widget.run['location'].toString();
    distanceController.text = widget.run['distance'].toString();
    participantsController.text = widget.run['participants'].toString();
  }

  Future<void> updateRun() async {
    final location = locationController.text.trim();
    final distance = double.tryParse(distanceController.text);
    final participants = int.tryParse(participantsController.text);

    if(location.isEmpty || distance == null || participants == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ข้อมูลไม่ถูกต้อง',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try{
      await Supabase.instance.client.from('runs').update({
        'location': location,
        'distance': distance,
        'participants': participants,
      }).eq('id', widget.run['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'อัปเดตสำเร็จ',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteRun() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'ยืนยันการลบ',
        ),
        content: const Text(
          'ต้องการลบข้อมูลนี้ใช่ไหม',
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
              try{
                await Supabase.instance.client
                    .from('runs')
                    .delete()
                    .eq('id', widget.run['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'ลบสำเร็จ',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context, true);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error: $e',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'ลบ',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    locationController.dispose();
    distanceController.dispose();
    participantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF090359),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'แก้ไข/ลบ', 
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'สถานที่',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: distanceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'ระยะทาง (km)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: participantsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'จำนวนคน',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: isLoading ? null : updateRun,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                    'อัปเดต', 
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: deleteRun,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'ลบ', 
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
