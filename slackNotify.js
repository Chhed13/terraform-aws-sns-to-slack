// https://medium.com/cohealo-engineering/how-set-up-a-slack-channel-to-be-an-aws-sns-subscriber-63b4d57ad3ea#.wddygog5v

exports.handler = function(event, context) {
    var https = require('https');
    var util = require('util');

    console.log(JSON.stringify(event, null, 2));
    console.log('From SNS:', event.Records[0].Sns.Message);
    console.log('notify and error channels:', process.env.NOTIFY_CHANNEL, process.env.ERROR_CHANNEL);

    var message = event.Records[0].Sns.Message;
    var color = "good"; //  good, warning, danger
    var subject = event.Records[0].Sns.Subject;

    lMessage = message.toLowerCase();
    lSubject = subject.toLowerCase();
    post_to_err = false;
    if (lMessage.indexOf("warn") >= 0 || lSubject.indexOf("warning") >= 0){
        console.log("color set to warning");
        color = "warning"
    }
    if (lMessage.indexOf("error") >= 0 || lSubject.indexOf("error") >= 0){
        console.log("color set to danger");
        color = "danger";
        post_to_err = true;
    }

    var postData = {
        "username": process.env.USERNAME,
        "text": "*" + subject + "*",
        "icon_emoji": process.env.ICON_EMOJI,
        "attachments": [
            {
                "color": color,
                "text": message
            }
        ]
    };

    var options = {
        method: 'POST',
        hostname: 'hooks.slack.com',
        port: 443,
        path: process.env.WEBHOOK_PATH
    };

    var req = https.request(options, function(res) {
      res.setEncoding('utf8');
      res.on('data', function () {
        context.done(null);
      });
    });

    req.on('error', function(e) {
      console.log('problem with request: ' + e.message);
    });

    postData.channel = process.env.NOTIFY_CHANNEL;
    req.write(util.format("%j", postData));
    req.end();

    // if it's in error/danger state - send to error channel
    if (post_to_err && process.env.ERROR_CAHNNEL !== '') {
        console.log('sending to error channel');

        req = https.request(options, function(res) {
            res.setEncoding('utf8');
            res.on('data', function () {
                context.done(null);
            });
        });

        req.on('error', function(e) {
            console.log('problem with request: ' + e.message);
        });

        postData.channel = process.env.ERROR_CHANNEL;
        req.write(util.format("%j", postData));
        req.end();
    }
};