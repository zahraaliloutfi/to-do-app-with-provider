import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled4/shared/cubit/states.dart';

import '../../models/todo/new_archived.dart';
import '../../models/todo/new_done.dart';
import '../../models/todo/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  // AppCubit(super.initialState);

//object from class appcubit :
   static AppCubit get( context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> tasks = [NewTasks(), NewDone(), NewArcived()];
  List<String> titles = ['Tasker', 'Done', 'Archived'];

  void changeIndex (int index){
    currentIndex = index;
    emit(AppChangeNavBarState());
    
  }



}
