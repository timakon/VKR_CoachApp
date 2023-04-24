const router = require("express").Router();
const trainingsController = require("../controllers/trainingsController");

router.route("/").get(trainingsController.getAllTrainings);
router.route("/:id").get(trainingsController.getTrainingById);
router.route("/add").post(trainingsController.addTraining);
router.route("/update/:id").put(trainingsController.updateTraining);
router.route("/delete/:id").delete(trainingsController.deleteTraining);

module.exports = router;
