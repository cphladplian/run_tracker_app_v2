import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRunUi extends StatefulWidget {
  const AddRunUi({super.key});

  @override
  State<AddRunUi> createState() => _AddRunUiState();
}

class _AddRunUiState extends State<AddRunUi> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();

  bool isLoading = false;

  Future<void> insertRun() async {
    final location = locationController.text.trim();
    final distanceText = distanceController.text.trim();
    final participantsText = participantsController.text.trim();

    if (location.isEmpty || distanceText.isEmpty || participantsText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'กรุณากรอกข้อมูลให้ครบ',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final distance = double.tryParse(distanceText);
    final participants = int.tryParse(participantsText);

    if (distance == null ||
        distance <= 0 ||
        participants == null ||
        participants <= 0) {
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

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'กรุณา login ก่อน',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await Supabase.instance.client.from('runs').insert({
        'location': location,
        'distance': distance,
        'participants': participants,
        'user_id': user.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'เพิ่มข้อมูลสำเร็จ',
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
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: const Text(
          'เพิ่มข้อมูล', 
          style: TextStyle(
            color: Colors.white
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
              onPressed: isLoading ? null : insertRun,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'บันทึก',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                locationController.clear();
                distanceController.clear();
                participantsController.clear();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'ล้างข้อมูล',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
