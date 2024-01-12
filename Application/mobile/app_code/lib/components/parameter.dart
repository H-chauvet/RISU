import 'package:flutter/material.dart';
import 'package:risu/utils/check_signin.dart';
import '../globals.dart';
import 'divider.dart';

enum DIVIDERPLACE {
  top,
  bottom,
}

class MyRedirectDivider extends StatelessWidget {
  final String title;
  final Widget goToPage;
  final Widget paramIcon;
  final bool disconnect;
  final DIVIDERPLACE chosenPlace;

  const MyRedirectDivider({
    super.key,
    required this.title,
    required this.goToPage,
    required this.paramIcon,
    this.disconnect = false,
    this.chosenPlace = DIVIDERPLACE.bottom,
  });

  void onChanging(BuildContext context) {
    if (userInformation == null) {
      checkSignin(context);
      return;
    } else {
      if (disconnect) {
        userInformation = null;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return goToPage;
            },
          ),
          (route) => false,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return goToPage;
            },
          ),
        );
      }
    }
  }

  Widget placeDivider(DIVIDERPLACE currPlace) {
    if (chosenPlace == currPlace) {
      return const MyDivider();
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            onChanging(context);
          },
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            placeDivider(DIVIDERPLACE.top),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: paramIcon,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ]),
            placeDivider(DIVIDERPLACE.bottom),
          ]),
        ));
  }
}

class MyParameter extends StatelessWidget {
  final String title;
  final Widget goToPage;
  final Widget paramIcon;
  final bool locked;

  const MyParameter({
    super.key,
    required this.title,
    required this.goToPage,
    required this.paramIcon,
    this.locked = false,
  });

  Widget correspondingIcon() {
    if (locked) {
      return const Icon(Icons.lock);
    }
    return const Icon(Icons.chevron_right);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (locked) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return goToPage;
            },
          ),
        );
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: paramIcon,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Expanded(child: SizedBox()),
          correspondingIcon()
        ]),
        const MyDivider()
      ]),
    );
  }
}
