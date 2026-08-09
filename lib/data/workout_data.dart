import 'package:fitness_app_flutter/models/exercise.dart';
import 'package:fitness_app_flutter/models/workout.dart';
import 'package:flutter/material.dart';

class WorkoutData extends ChangeNotifier {
  // Workout structure
  // each workout has a name and list of exercises

  List<Workout> workoutList = [
    // defualt workout
    Workout(
      name: "Upper Body",
      exercise: [
        Exercise(name: "Bicep Curls", weight: "10", reps: "10", sets: "3"),
      ],
    ),
  ];

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //get length of workout
  int numberOfExerciseInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercise.length;
  }

  //add a workout
  void addWorkout(String name) {
    //add a new workout list
    workoutList.add(Workout(name: name, exercise: []));

    notifyListeners();
  }

  // add an excersie to a workout
  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    //find relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercise.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );
    notifyListeners();
  }

  //check off the excersie
  void checkOffExercise(String workoutName, String exerciseName) {
    //find relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    //check off bolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
  }

  // return relevant workout objecct, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = workoutList.firstWhere(
      (workout) => workout.name == workoutName,
    );
    return relevantWorkout;
  }

  // return relevant exercise object give a wrokout name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    // then find relevant exercise
    Exercise relevantExercise = relevantWorkout.exercise.firstWhere(
      (exercise) => exercise.name == exerciseName,
    );

    return relevantExercise;
  }
}
