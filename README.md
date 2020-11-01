# Video browser, player and editor (simple predefined overlays)

This is a simple Qt Quick C++ app browse, play and edit videos.

## Import video

User needs to select directory first. After directory is selected, raw (unedited) and/or previously edited videos are shown in a list view bellow. Allready edited videos can not be edited so icon next to video thumbnail is not shown. Click on video opens new screen thah just plays video, while click on edit icon plays video and displays edit features.

![select _video_ss](https://user-images.githubusercontent.com/37535693/97810793-ba2a8700-1c76-11eb-985e-06f987e6bdc5.png)

## Edit video

If user selected video editing, controls for overlays are displayed on rightside of an app window. User can include up to three ovelay:
1. Randomly generated number every 300 ms
2. Rectangle that randomly changes position and gradient color every 1000 ms
3. Progress bar that is incrementing until MAX value and decrementing until MIN value every 500 ms



