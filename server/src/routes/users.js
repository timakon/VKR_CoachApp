const router = require("express").Router();
const usersController = require("../controllers/usersController");

router.route("/").get(usersController.getAllUsers);
router.route("/clients").get(usersController.getAllClients);
router.route("/:id").get(usersController.getUserById);
router.route("/add").post(usersController.addUser);
router.route("/update/:id").put(usersController.updateUser);
router.route("/delete/:id").delete(usersController.deleteUser);

module.exports = router;