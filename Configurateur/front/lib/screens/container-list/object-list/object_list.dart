import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
// import 'package:front/screens/container-list/container_web.dart';
import 'package:front/screens/container-list/object-list/object_component.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ObjectPage extends StatefulWidget {
  final int? containerId;
  const ObjectPage({Key? key, required int? this.containerId}) : super(key: key);

  @override
  _ObjectPageState createState() => _ObjectPageState(containerId: containerId);
}

class _ObjectPageState extends State<ObjectPage> {
  final int? containerId;
  _ObjectPageState({required this.containerId});
  List<ObjectList> objects = [];

  @override
  void initState() {
    super.initState();
    fetchObjects();
  }

  Future<void> fetchObjects() async {
    final response = await http.get(
      Uri.parse('http://${serverIp}:3000/api/object/listAll?containerId=$containerId'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> objectsData = responseData["object"];
      setState(() {
        objects = objectsData.map((data) => ObjectList.fromJson(data)).toList();
      });
    } else {
    }
  }

  Future<void> deleteObject(ObjectList message) async {
    final Uri url = Uri.parse("http://${serverIp}:3000/api/object/delete");
    final response = await http.post(
      url,
      body: json.encode({'id': message.id}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(
      //   msg: 'Message supprimé avec succès',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
      fetchObjects();
    } else {
      // Fluttertoast.showToast(
      //   msg: 'Erreur lors de la suppression du message: ${response.statusCode}',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(
        'Gestion des conteneurs',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            ListView.builder(
              shrinkWrap:
                  true,
              itemCount: objects.length,
              itemBuilder: (context, index) {
                final product = objects[index];
                return ObjectCard(
                  object: product,
                  onDelete: deleteObject,
                );
                // return Text("$itemId");
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
