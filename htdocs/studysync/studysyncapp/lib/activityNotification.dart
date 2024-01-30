import 'package:awesome_notifications/awesome_notifications.dart';

scheduleActivityNotif(deadlineDateTime, activityId) async {

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: activityId,
      channelKey: 'basic_channel',
      title: 'Activity Overdue',
      body: 'Activity went past deadline, check app for details',
      wakeUpScreen: true,
      autoDismissible: false,
      locked: true,
      fullScreenIntent: true,
      category: NotificationCategory.Alarm,
      notificationLayout: NotificationLayout.BigText,
    ),
    schedule: NotificationCalendar(
      minute: deadlineDateTime.minute,
      hour: deadlineDateTime.hour,
      day: deadlineDateTime.day,
      weekday: deadlineDateTime.weekday,
      month: deadlineDateTime.month,
      year: deadlineDateTime.year,
      preciseAlarm: true,
      allowWhileIdle: true,
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
    ),
    actionButtons: [
      NotificationActionButton(
        key: "Close",
        label: "Close Reminder",
        autoDismissible: true
      )
    ]
  );
  print('deadline $deadlineDateTime');
  print('scheduled notif');
}