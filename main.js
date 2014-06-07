var util  = require('util'),
    spawn = require('child_process').spawn,
    hubot    = spawn('npm', ['start']);

hubot.stdout.on('data', function (data) {
    console.log('stdout: ' + data);
});

hubot.stderr.on('data', function (data) {
    console.log('stderr: ' + data);
});

hubot.on('exit', function (code) {
    console.log('child process exited with code ' + code);
});