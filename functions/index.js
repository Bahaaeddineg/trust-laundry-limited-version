const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
exports.sendNotificationsToAllTheUsers = functions.firestore
    .document('notifications/{notificationId}')
    .onCreate(async (snap, context) => {
        
    });


exports.notifyEmailUpdate = functions.firestore
    .document("users/{userId}")
    .onUpdate((change, context) => {
        // Get the data before and after the update
        const beforeData = change.before.data();
        const afterData = change.after.data();

        // Check if the email field has changed
        if (beforeData.email !== afterData.email) {
            const userId = context.params.userId;
            const newEmail = afterData.email;

            // Assume the user's device token is stored in the document
            const userDeviceToken = afterData.fcmToken;

            if (userDeviceToken) {
                // Define the message payload
                const message = {
                    token: userDeviceToken, // Target specific device
                    notification: {
                        title: "Email Updated",
                        body: `Your email has been changed to ${newEmail}`,
                    },
                    data: {
                        userId: userId,
                        newEmail: newEmail,
                    },
                };

                // Send the message
                return admin.messaging().send(message)
                    .then((response) => {
                        console.log(`Notification sent to user ${userId}:`, response);
                        return null;
                    })
                    .catch((error) => {
                        console.error(`Error sending notification to user ${userId}:`, error);
                    });
            } else {
                console.warn(`No device token found for user ${userId}`);
                return null;
            }
        }

        return null;
    });

