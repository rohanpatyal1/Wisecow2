const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  res.send('Welcome to Wisecow App!');
});

app.listen(PORT, () => {
  console.log(`Wisecow app running on port ${PORT}`);
});
