const router = require("express").Router();
const authMiddleware = require("../middlewares/authMiddleware");
const usersController = require("../controllers/usersController");

router.route("/").get(authMiddleware, usersController.getAllUsers);
router.route("/clients").get(usersController.getAllClients);
router.route("/:id").get(usersController.getUserById);
router.route("/register").post(usersController.register);
router.route("/login").post(usersController.login);
router.route("/update/:id").put(usersController.updateUser);
router.route("/delete/:id").delete(usersController.deleteUser);

module.exports = router;