const AWS = require('aws-sdk');

require('aws-sdk/lib/maintenance_mode_message').suppress = true;
AWS.config.update({ region: "us-east-1" });

const rekognition = new AWS.Rekognition(
    {
        apiVersion: "2016-06-27"
    }
);

// nvm use lts/gallium
// npx serverless deploy --stage local
const threshold = 80;
const validLabels = [
    "Medical",
    "Body Part",
    "Head",
    "Face",
    "Human",
    "Injury",
    "Skin",
    "Neck",
    "Shoulder"
];

module.exports = {
    label: async (event, context) => {
        const request = event.body;
        const data = JSON.parse(request);
        const image = data.fileName;
        const detection = {
            "Image": {
                "S3Object": {
                    "Bucket": process.env.BUCKET,
                    "Name": image,
                }
            },
            "MaxLabels": 20,
            "MinConfidence": 75,
        };

        try {
            console.log("Analyzing");
            console.log(detection);

            const result = await rekognition.detectLabels(detection).promise();
            const labels = result.Labels;
            const matched = labels.some((label) => {
                console.log("Matching label=", label);

                if (validLabels.includes(label.Name) && label.Confidence >= threshold) {
                    console.log("Matched label=", label);
                    return true;
                }

                return false;
            });

            return {
                statusCode: 200,
                body: JSON.stringify({
                    "error": null,
                    "matched": matched,
                    "details": result,
                }),
            };
        } catch (error) {
            console.log(error);

            return {
                statusCode: 500,
                body: JSON.stringify({
                    "error": error.Message,
                    "matched": false,
                }),
            };
        }
    },
    ping: async (event, context) => {
        return {
            statusCode: 200,
            body: JSON.stringify({
                "ping": "PONG"
            }),
        };
    },
};
