// feedbacks_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/dialog/dialog_cubit.dart';
import 'package:front/components/dialog/rating_dialog_content.dart';
import 'package:front/components/footer.dart';

class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({Key? key}) : super(key: key);

  @override
  _FeedbacksPageState createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DialogCubit(),
      child: Scaffold(
        appBar: CustomAppBar('Les avis de RISU', context: context),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:const Color.fromARGB(255, 190, 189, 189),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlocProvider(
                    create: (context) => DialogCubit(),
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                      backgroundColor: Color.fromRGBO(179, 174, 174, 1),
                      child: Container(
                        width: 600.0,
                        height: 300.0,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Poster un avis',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          RatingDialogContent(),
                        ]
                        )
                        
                      ),
                    ),
                  );
                },
              );
            },
            child: const Text(
              'Poster un avis',
              style: TextStyle(color: Colors.black)
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
