import 'package:fitness_app_flutter/data/hive_database.dart';
import 'package:fitness_app_flutter/datetime/date_time.dart';
import 'package:fitness_app_flutter/models/exercise.dart';
import 'package:fitness_app_flutter/models/workout.dart';
import 'package:flutter/material.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

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

  //if there are workout already in database then get otherwise return default
  void intializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFormDatabase();
    } else {
      db.SaveToDatabase(workoutList);
    }

    //load heatmap
    loadHeatMap();
  }

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
    //save to database
    db.SaveToDatabase(workoutList);
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
    //save to database
    db.SaveToDatabase(workoutList);
  }

  //check off the excersie
  void checkOffExercise(String workoutName, String exerciseName) {
    //find relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    //check off bolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    //save to database
    db.SaveToDatabase(workoutList);

    //load heatmap
    loadHeatMap();
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

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count no of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start to today add each completion status
    //completion status will be key in db
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToYYYYMMDD(
        startDate.add(Duration(days: i)),
      );

      //completion status = 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      //year
      int year = startDate.add(Duration(days: i)).year;

      //month
      int month = startDate.add(Duration(days: i)).month;

      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus,
      };

      //add to the heat map
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
