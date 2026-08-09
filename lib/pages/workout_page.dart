import 'package:fitness_app_flutter/components/exercise_tile.dart';
import 'package:fitness_app_flutter/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox was tapped
  void onCheckChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).checkOffExercise(workoutName, exerciseName);
  }

  // text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  //create new excersie method
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a new Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //exercise name
            TextField(controller: exerciseNameController),
            //weight
            TextField(controller: weightController),
            //reps
            TextField(controller: repsController),
            //sets
            TextField(controller: setsController),
          ],
        ),
        actions: [
          //save
          MaterialButton(onPressed: save, child: Text("Save")),
          //cancel
          MaterialButton(onPressed: save, child: Text("Cancel")),
        ],
      ),
    );
  }

  //save workout
  void save() {
    //get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    // add exercise to workout data list
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).addExercise(widget.workoutName, newExerciseName, weight, reps, sets);

    //pop
    Navigator.pop(context);
    clear();
  }

  //cancel workout
  void cancel() {
    Navigator.pop(context);
  }

  // clear controller
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExerciseInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .name,
            weight: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .weight,
            reps: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .reps,
            sets: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .sets,
            isCompleted: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .isCompleted,
            onCheckChanged: (val) => onCheckChanged(
              widget.workoutName,
              value.getRelevantWorkout(widget.workoutName).exercise[index].name,
            ),
          ),
        ),
      ),
    );
  }
}
