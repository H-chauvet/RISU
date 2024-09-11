import 'package:flutter/material.dart';
import 'package:front/components/dialog/handle_member/handle_member_style.dart';
import 'package:front/services/size_service.dart';
import 'package:front/styles/globalStyle.dart';

// ignore: must_be_immutable

/// [StatefulWidget] : SaveDialogState
///
/// Create a new dialog to save container with specific [name]
class HandleMember extends StatefulWidget {
  HandleMember({
    super.key,
  });

  @override
  State<HandleMember> createState() => HandleMemberState();
}

/// HandleMemberState
///
class HandleMemberState extends State<HandleMember> {
  TextEditingController _controller = TextEditingController();
  String collaboratorContact = '';
  List<String> collaboratorList = ["test"];

  void addMember() {}

  /// [Widget] : Build the AlertDialog
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return AlertDialog(
      content: SizedBox(
        height: 500,
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ajouter un membre ?',
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Pour ajouter un membre à votre entreprise, indiquez son adresse mail. Il recevra un mail permettant de créer son compte",
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopInfoTextFontSize
                    : tabletInfoTextFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('collaboratorContact'),
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Entrez un mail pour inviter le collaborateur",
                      labelText: 'Mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      collaboratorContact = value!;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplir ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  key: const Key('send-button'),
                  onPressed: () => {
                    if (collaboratorContact != '')
                      {
                        addMember(),
                        collaboratorContact = '',
                        _controller.text = '',
                      }
                  },
                  icon: Icon(Icons.send),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey[400],
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Membres actuelles',
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: collaboratorList.length,
                itemBuilder: (_, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(collaboratorList[i]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                collaboratorList.removeAt(i);
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                collaboratorList.removeAt(i);
                              });
                            },
                            icon: Icon(Icons.delete),
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
