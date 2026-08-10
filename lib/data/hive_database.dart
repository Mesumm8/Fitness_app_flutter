import 'package:fitness_app_flutter/datetime/date_time.dart';
import 'package:fitness_app_flutter/models/exercise.dart';
import 'package:fitness_app_flutter/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  // refer hive box
  final myBox = Hive.box("workout_database2");

  // check if there is data stored if not record start
  bool previousDataExists() {
    if (myBox.isEmpty) {
      myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return myBox.get("START_DATE") ?? todaysDateYYYYMMDD();
  }

  // write data to hive
  void SaveToDatabase(List<Workout> workouts) {
    // 1. Convert workout objects into lists of strings
    final workoutList = convertObjectToWorkoutList(workouts); // 👈 Fixed method call
    final exerciseList = convertObjectToExerciseList(workouts);

    // 2. Save completion status (with consistent key naming)
    if (exerciseCompleted(workouts)) {
      myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1); // 👈 Added underscore '_'
    } else {
      myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    // 3. Save into hive
    myBox.put("WORKOUTS", workoutList);
    myBox.put("EXERCISES", exerciseList);
  }

  // read data, return list of workouts
  List<Workout> readFormDatabase() {
    List<Workout> mySavedWorkouts = [];

    // Safe casting using List<String>.from to prevent type errors
    List<String> workoutNames = List<String>.from(myBox.get("WORKOUTS") ?? []);
    List<dynamic> exerciseDetails = myBox.get("EXERCISES") ?? [];

    // create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInEachWorkout = [];
      List<dynamic> currentWorkoutExercises = exerciseDetails[i] as List<dynamic>;

      // Loop through exercises in this specific workout
      for (int j = 0; j < currentWorkoutExercises.length; j++) { // 👈 Fixed .length check
        List<String> details = List<String>.from(currentWorkoutExercises[j] as List);

        exercisesInEachWorkout.add(
          Exercise(
            name: details[0],
            weight: details[1],
            reps: details[2],
            sets: details[3],
            isCompleted: details[4] == 'true',
          ),
        );
      }

      // Create individual workout object OUTSIDE the exercise loop
      Workout workout = Workout(
        name: workoutNames[i],
        exercise: exercisesInEachWorkout,
      );

      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  // check if exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercise) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return completion status
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

// converts workout obj into list of names
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];
  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }
  return workoutList;
}

// converts exercise in workout obj into list of list of string
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercise;
    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        exercisesInWorkout[j].name,
        exercisesInWorkout[j].weight,
        exercisesInWorkout[j].reps,
        exercisesInWorkout[j].sets,
        exercisesInWorkout[j].isCompleted.toString(),
      ];
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}