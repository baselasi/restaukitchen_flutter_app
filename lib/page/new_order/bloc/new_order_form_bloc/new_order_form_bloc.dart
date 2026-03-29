import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

class NewOrderFormBloc extends Bloc<NewOrderFormEvent, NewOrderFormState> {
  NewOrderFormBloc({int tableNumber = 0, int totalCovers = 0})
    : super(
        NewOrderFormState(
          courses: [Course(disheIndices: [])],
          tableNumber: tableNumber,
          totalCovers: totalCovers,
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
    on<SetCurrentCourseIndex>((event, emit) {
      emit(state.copyWith(currentCourseIndex: event.courseIndex));
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
    final updatedCourses = List<Course>.from(state.courses)..add(event.course);
    emit(
      state.copyWith(
        courses: updatedCourses,
        currentCourseIndex: updatedCourses.length - 1,
      ),
    );
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
    final updatedCourses = List<Course>.from(state.courses);
    final currentCourse = updatedCourses[event.courseIndex];
    final updatedIndices = List<CourseIndice>.from(currentCourse.disheIndices)
      ..add(event.courseIndice);
    updatedCourses[event.courseIndex] = Course(disheIndices: updatedIndices);
    emit(state.copyWith(courses: updatedCourses));
  }

  void _onRemoveDishIndice(
    RemoveDishIndice event,
    Emitter<NewOrderFormState> emit,
  ) {
    final updatedCourses = List<Course>.from(state.courses);
    final currentCourse = updatedCourses[event.courseIndex];
    final updatedIndices = List<CourseIndice>.from(currentCourse.disheIndices)
      ..removeAt(event.dishIndiceIndex);
    updatedCourses[event.courseIndex] = Course(disheIndices: updatedIndices);
    emit(state.copyWith(courses: updatedCourses));
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
