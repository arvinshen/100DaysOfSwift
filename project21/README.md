# Local Notifications


<!-- Table of Contents -->
## Table of Contents
* [About The Project](#about-the-project)
* [Concepts Utilized](#concepts-utilized)
* [Screenshots](#screenshots)
* [Acknowledgements](#acknowledgements)


<!-- ABOUT THE PROJECT -->
## About The Project

Local Notifications is an app that sends reminders to the user's lock screen and show them information when the app isn't running.

#### [Challenges](https://www.hackingwithswift.com/read/21/4/wrap-up)
>1. Update the code in didReceive so that it shows different instances of UIAlertController depending on which action identifier was passed in.
>2. For a harder challenge, add a second UNNotificationAction to the alarm category of project 21. Give it the title “Remind me later”, and make it call scheduleLocal() so that the same alert is shown in 24 hours. (For the purpose of these challenges, a time interval notification with 86400 seconds is good enough – that’s roughly how many seconds there are in a day, excluding summer time changes and leap seconds.)
>3. And for an even harder challenge, update project 2 so that it reminds players to come back and play every day. This means scheduling a week of notifications ahead of time, each of which launch the app. When the app is finally launched, make sure you call removeAllPendingNotificationRequests() to clear any un-shown alerts, then make new alerts for future days.

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- CONCEPTS UTILIZED -->
## Concepts Utilized
* UNUserNotificationCenter
* Requesting Permission for Notifications
* Different Kinds of Notification Triggers

Note: P21 Challenge 3 modifies a copy of P2 from P15 Challenge 3.

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- SCREENSHOTS -->
## Screenshots
In Progress

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
Hacking With Swift - [100 Days of Swift] by Paul Hudson

Project 21 - Local Notifications is coded in correspondence to the following days:
* [Day 72]
* [Day 73] - Challenge Day

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[100 Days of Swift]: https://www.hackingwithswift.com/100 (100 Days of Swift)
[Day 72]: https://www.hackingwithswift.com/100/72
[Day 73]: https://www.hackingwithswift.com/100/73
