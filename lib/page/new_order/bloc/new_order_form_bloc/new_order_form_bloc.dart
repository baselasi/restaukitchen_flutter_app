import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

class NewOrderFormBloc extends Bloc<NewOrderFormEvent, NewOrderFormState> {
  NewOrderFormBloc()
    : super(
        NewOrderFormState(
          courses: [Course(disheIndices: [])],
          tableNumber: 0,
          totalCovers: 0,
          total: 0,
          orderTime: DateTime.now(),
          currentCourseIndex: 0,
        ),
      ) {
    on<AddCourse>((event, emit) {
      _onAddCourse(event, emit);
    });
    on<RemoveCourse>((event, emit) {
      _onRemoveCourse(event, emit);
    });
    on<UpdateCourse>((event, emit) {
      _onUpdateCourse(event, emit);
    });
    on<AddDishIndice>((event, emit) {
      _onAddDishIndice(event, emit);
    });
    on<RemoveDishIndice>((event, emit) {
      _onRemoveDishIndice(event, emit);
    });
    on<DeleteDishIndice>((event, emit) {
      _onDeleteDishIndice(event, emit);
    });
    on<UpdateDishIndice>((event, emit) {
      _onUpdateDishIndice(event, emit);
    });
  }

  void _onAddCourse(AddCourse event, Emitter<NewOrderFormState> emit) {
    // final courses = state.courses;
    // courses.add(Course(disheIndices: []));
    // emit(state.copyWith(courses: courses));
  }

  void _onRemoveCourse(RemoveCourse event, Emitter<NewOrderFormState> emit) {
    // final courses = state.courses;
    // courses.removeAt(event.index);
    // emit(state.copyWith(courses: courses));
  }

  void _onUpdateCourse(UpdateCourse event, Emitter<NewOrderFormState> emit) {
    // final courses = state.courses;
    // courses[event.index] = event.course;
    // emit(state.copyWith(courses: courses));
  }

  void _onAddDishIndice(AddDishIndice event, Emitter<NewOrderFormState> emit) {
    final courses = state.courses;
    courses[event.courseIndex].disheIndices.add(event.dishIndice);
    emit(state.copyWith(courses: courses));
  }

  void _onRemoveDishIndice(
    RemoveDishIndice event,
    Emitter<NewOrderFormState> emit,
  ) {
    // final courses = state.courses;
    // courses[event.courseIndex].disheIndices.removeAt(event.dishIndiceIndex);
    // emit(state.copyWith(courses: courses));
  }

  void _onDeleteDishIndice(
    DeleteDishIndice event,
    Emitter<NewOrderFormState> emit,
  ) {
    // final courses = state.courses;
    // courses[event.courseIndex].disheIndices.removeAt(event.dishIndiceIndex);
    // emit(state.copyWith(courses: courses));
  }

  void _onUpdateDishIndice(
    UpdateDishIndice event,
    Emitter<NewOrderFormState> emit,
  ) {
    // final courses = state.courses;
    // courses[event.courseIndex].disheIndices[event.dishIndiceIndex] = event.dishIndice;
    // emit(state.copyWith(courses: courses));
  }
}
