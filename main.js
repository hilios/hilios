var capturejs = require('./capture');
var restify = require('restify');
var crypto = require('crypto');
var path = require('path')
var fs = require('fs');
var gm = require('gm')

var server = restify.createServer({
  name: 'extras',
  version: '1.0.0'
});
server.use(restify.acceptParser(server.acceptable));
server.use(restify.gzipResponse());
server.use(restify.queryParser());

function readFile(path, r) {
  try {
    f = fs.readFileSync(path);
    r.write(f);
    r.end();
  } catch(e) {
    r.writeHead(500);
    r.end('');
  }
}

function capture(url, path, r) {
  capturejs.capture({
    timeout: 120000,
    uri: url,
    output: path,
    cliprect: '0x0x1280x720',
    viewportsize: '1280x769'
  }, function(err) {
    if (err) {
      r.writeHead(500);
      r.end('');
    } else {
      // Resize
      gm(path).resize(800).write(path, function(err) {});
      readFile(path, r);
    }
  });
}

server.get('/p', function (req, res, next) {
  var url = req.query['q'];

  if (url === undefined) {
    res.writeHead(400);
    res.end('');
    return next();
  }
  // Generate the filename to cache
  var cache = crypto.createHash('md5').update(url).digest('hex');
  var filepath = path.join(process.cwd(), 'tmp', cache) + '.png';

  if (!fs.existsSync(filepath)) {
    capture(url, filepath, res);
  } else {
    readFile(filepath, res);
  }
});

server.listen(8080, function () {
  console.log('%s listening at %s', server.name, server.url);
});
