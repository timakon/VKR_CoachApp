const Training = require("../models/trainings");

exports.getAllTrainings = async (req, res) => {
  try {
    const trainings = await Training.find();
    res.status(200).json(trainings);
  } catch (error) {
    res.status(400).json("Error: " + error);
  }
};
exports.getTrainingById = async (req, res) => {
    try {
      const training = await Training.findById(req.params.id);
      res.status(200).json(training);
    } catch (error) {
      res.status(400).json("Error: " + error);
    }
  };
  
exports.addTraining = async (req, res) => {
    const newTraining = new Training(req.body);
    console.log(newTraining)
  
    try {
      await newTraining.save();
      res.status(201).json(newTraining);
    } catch (error) {
      res.status(400).json("Error: " + error);
    }
  };
  
exports.updateTraining = async (req, res) => {
  console.log(req.body);
    try {
      await Training.findByIdAndUpdate(req.params.id, req.body);
      res.status(200).json("Training updated successfully");
    } catch (error) {
      res.status(400).json("Error: " + error);
    }
  };
  
exports.deleteTraining = async (req, res) => {
    try {
      await Training.findByIdAndDelete(req.params.id);
      res.status(200).json("Training deleted successfully");
    } catch (error) {
      res.status(400).json("Error: " + error);
    }
  };