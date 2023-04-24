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

exports.addUser = async (req, res) => {
  const newUser = new User(req.body);

  try {
    await newUser.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json("Error: " + error);
  }
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
