# File Ninja

File Ninja is a cross-platform tool that helps you capture and instantly combine images into a PDF file then share it to your computer during online written exams.

### Inspiration
As part of remote education, students are supposed to take online exams, some of which require you to write solutions on paper and submit them through an online portal. To work through this, students like ourselves have been taking pictures of their solutions via mobile phones, sharing those pictures to their computers, converting all of them into a single PDF file and finally submitting it to their instructors.

Tedious, right? From our experiences, we've had to submit them after the deadline, resulting into late submissions.

**WHAT IF WE COULD AUTOMATE THIS PROCESS?**
Good news! We  have File Ninja.

File Ninja helps you:

- Select or capture images from your mobile phone
- Automatically combine all of them into a single PDF file
- Instantly download the file on your computer

### Process
We have tried to make the process as simple as possible, so we've created a mobile app that instantly uploads selected pictures to the server and gives you a unique access code. To download those files on the computer, you need to go to [fileninja.tk](https://fileninja.tk) and enter the access code.

The PDF file with all the images will be automatically created and a download will be triggered. You can now use the downloaded PDF file to submit to your instructor or share it wherever you want.

**For testing purposes, you can find the Android app at:**
```
file-ninja-app/apk-release.apk
```

**or Download a [zip file](https://fileninja.tk/downloads/file-ninja-apk.zip).**

### Privacy
The uploaded files will be automatically deleted from our server after 30 minutes. See our [Privacy Policy](https://fileninja.tk/privacy-policy).

****

### Tech

- UI Design [`file-ninja-UI-design`] - **[Adobe XD](https://www.adobe.com/products/xd.html)**
- Mobile App (Android + iOS) [`file-ninja-app`] - **[Flutter](https://flutter.dev/)**
- Website [`file-ninja-website`] & Chrome Extension [`file-ninja-chrome-extension`] - **HTML**, **JavaScript**
- Server-side [`file-ninja-server-side`] - **[PHP](https://php.net)**

To delete files after 30 minutes, we have scheduled a Cron Job that executes a cleanup script on the server every minute.

### Challenges
For the best experience, the app needs to communicate with the server as fast as possible. Although the current server we've set up has a good response time, we need to properly plan for scalability. In addition, we will require enough storage for the files to be uploaded without errors. Therefore, we are looking forward to setting up a dedicated server on the cloud (Amazon AWS or Microsoft Azure) once we start receiving enough users.

### The Future of File Ninja
As this is the first build of File Ninja, we're clearly not sure if our users will find it helpful or will prefer any other way around this problem. So, if we reach a good amount of users, we see the following prospects at the moment:

- Support for other file formats rather than just images
- Support for very large files
- Keeping track of where the files were accessed
- Local file sharing
- File sharing between multiple mobile devices
- A Desktop application for file downloads

Thank you!
