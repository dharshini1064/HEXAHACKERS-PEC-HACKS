const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));

// Connect to MongoDB
mongoose.connect('mongodb://127.0.0.1:5500/campaignmsm.html/formDataDB', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Failed to connect to MongoDB:', err));

// Schema and Model
const formSchema = new mongoose.Schema({
  name: String,
  email: String
});
const FormData = mongoose.model('FormData', formSchema);

// Route to handle form submission
app.post('/submit', async (req, res) => {
  const { name, email } = req.body;

  // Save data to MongoDB
  const newFormData = new FormData({ name, email });
  try {
    await newFormData.save();
    res.send('Form data saved successfully!');
  } catch (err) {
    res.status(500).send('Failed to save data.');
    console.error(err);
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:5500`);
});
