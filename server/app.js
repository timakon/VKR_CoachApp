const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");

// Импорт маршрутов
const trainingRoutes = require("./src/routes/trainings");
const userRoutes = require("./src/routes/users");

const app = express();
app.use(cors());
app.use(express.json());

// Настройка подключения к MongoDB
const uri = 'mongodb://localhost:27017/knir';
mongoose.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true });
const connection = mongoose.connection;
connection.once("open", () => {
  console.log("MongoDB database connection established successfully");
});

// Использование маршрутов
app.use("/trainings", trainingRoutes);
app.use("/users", userRoutes);

const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`Server is running on port: ${port}`);
});