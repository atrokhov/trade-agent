import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var title = 'Push Notification'
    var body = data
    var options = { body: body }
    new Notification(title, options)
  }
});
