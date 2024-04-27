const express = require('express');
const app = express();
const cors = require("cors")
const morgan = require("morgan")
const { PORT } = require("./config")

app.use(cors());
app.use(express.json());
app.use(morgan("tiny"));

// Simple route for GET request
app.get('/api', (req, res) => {
  res.json({ message: "Hello from server!" });
});

app.use((err, req, res, next) => {
    const status = err.status || 500
    const message = err.message
  
    return res.status(status).json({
      error: { message, status },
    })
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
