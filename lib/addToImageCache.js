var imageCache = require('./imageCache');

module.exports = function (req, res, next) {
  var repo = req.body.repo;
  imageCache[repo] = true;
  res.json(201, repo);
};