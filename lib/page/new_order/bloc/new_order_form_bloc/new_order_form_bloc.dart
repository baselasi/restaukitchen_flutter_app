import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';

class NewOrderFormBloc extends Bloc<NewOrderFormEvent, NewOrderFormState> {
  NewOrderFormBloc({int tableNumber = 0, int totalCovers = 0, Order? order})
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
    on<InitializeOrder>((event, emit) {
      _initializeOrder(event.order, emit);
    });
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
    add(InitializeOrder(order: order));
  }

  void _initializeOrder(Order? order, Emitter<NewOrderFormState> emit) {
    if (order == null) {
      emit(
        NewOrderFormState(
          courses: [Course(disheIndices: [])],
          tableNumber: state.tableNumber,
          totalCovers: state.totalCovers,
          total: 0,
          orderTime: DateTime.now(),
          currentCourseIndex: 0,
        ),
      );
    } else {
      emit(_getNewOrderFormState(order));
    }
  }

  /// Builds form state from [order.dishIndices], grouping each [CourseIndice]
  /// into a [Course] by its `course` number (sorted ascending).
  NewOrderFormState _getNewOrderFormState(Order order) {
    final indices = order.dishIndices;
    final List<Course> courses;
    if (indices == null || indices.isEmpty) {
      courses = [Course(disheIndices: [])];
    } else {
      final byCourse = <int, List<CourseIndice>>{};
      for (final indice in indices) {
        final n = _courseNumberForIndice(indice);
        byCourse.putIfAbsent(n, () => []).add(indice);
      }
      final sortedKeys = byCourse.keys.toList()..sort();
      courses = sortedKeys
          .map((k) => Course(disheIndices: byCourse[k]!))
          .toList();
    }
    return NewOrderFormState(
      courses: courses,
      tableNumber: order.tableNumber ?? 0,
      totalCovers: order.totalCovers,
      total: order.total ?? 0,
      orderTime: order.orderTime ?? DateTime.now(),
      currentCourseIndex: 0,
    );
  }

  int _courseNumberForIndice(CourseIndice indice) {
    return switch (indice) {
      DishIndice(:final course) => course,
      CombinationIndice(:final course) => course,
    };
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
    final updatedCourses = List<Course>.from(state.courses);
    final currentCourse = updatedCourses[event.courseIndex];
    final updatedIndices = List<CourseIndice>.from(currentCourse.disheIndices)
      ..replaceRange(event.dishIndiceIndex, event.dishIndiceIndex + 1, [
        event.dishIndice,
      ]);
    updatedCourses[event.courseIndex] = Course(disheIndices: updatedIndices);
    emit(state.copyWith(courses: updatedCourses));
  }
}
