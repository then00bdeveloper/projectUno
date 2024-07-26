# projectUno
This is my final year project for BIT.
The Parent is a Dart/Flutter interface for the parent to monitor child's device, such as setting time limits and blocking app usage. It should be installed in the parent's device.
MyApplication is a Java app with a service to upload app data and usage stats to firestore.
Reaper is another Java app with a service to block apps.
Both Reaper and MyApplication are installed in child's device and work together to achieve the intended functionality. i separated them because for some reason, the blocking service in Reaper couldn't work in MyApplication, so yeah. 
My project is very crude, i learned Flutter in class last semester, and i learned Java as i made the project.
