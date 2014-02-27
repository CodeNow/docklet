var docker = require('./docker');

function find(req, res, next) {
  req.body.job = true;
  return docker.findImage(req.body, function(err, ip) {
    if (err) {
      return res.send(err.code || 500, err.message);
    } else {
      return res.json(ip);
    }
  });
}

module.exports = find;