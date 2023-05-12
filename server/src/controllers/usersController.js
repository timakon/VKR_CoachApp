const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");

const User = require("../models/user");

exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (error) {
    res.status(400).json("Error: " + error);
  }
};

exports.getAllClients = async (req, res) => {
  try {
    const clients = await User.find({ role: "client" });
    res.status(200).json(clients);
  } catch (error) {
    res.status(400).json("Error: " + error);
  }
};

exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    res.status(200).json(user);
  } catch (error) {
    res.status(400).json("Error: " + error);
  }
};

exports.register = async (req, res) => {
  const hashedPassword = await bcrypt.hash(req.body.password, 10);
  const newUser = new User({
    name: req.body.name,
    email: req.body.email,
    password: hashedPassword,
    role: req.body.role,
  });
  try {
    await newUser.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json("Error: " + error);
  }
};

exports.login = async (req, res) => {
  const user = await User.findOne({ email: req.body.email });
  if (!user) return res.status(400).send("Email or password is incorrect");

  const validPass = await bcrypt.compare(req.body.password, user.password);
  if (!validPass) return res.status(400).send("Username or password is incorrect");
  console.log(user);

  const token = jwt.sign({ _id: user._id }, "mysecretkey123!");
  res.header("Authorization", token).send({ token: token, role: user.role, userId: user._id});
};

exports.updateUser = async (req, res) => {
  try {
    await User.findByIdAndUpdate(req.params.id, req.body);
    res.status(200).json("User updated successfully");
  } catch (error) {
    res.status(400).json("Error: " + error);
  }
};

exports.deleteUser = async (req, res) => {
    try {
      await User.findByIdAndDelete(req.params.id);
      res.status(200).json("User deleted successfully");
    } catch (error) {
      res.status(400).json("Error: " + error);
    }
  };
