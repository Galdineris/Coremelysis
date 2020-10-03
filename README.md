# Coremelysis


![Platform iOS](https://img.shields.io/badge/platform-iOS-blue)


Coremelysis is an app for experience sampling that uses machine learning for sentiment analysis.

## Installation
This app was developed for iOS 13.0 with XCode 12.
It is not avaiable on App Store. To run the app, please follow the instructions bellow.

Warning: This process requires an Apple Developer account.

1. Clone or download Coremelysis from this repo.
2. Open Coremelysis/Coremelysis.xcodeproj in Xcode.
3. Select the "Signing & Capabilities" tab in the Coremelysis project file.
4. Change the "Team" to your Apple Developer account team.
5. Change the "Bundle Identifier" to com.yourdomain.Kotoba.
6. Open the "Devices and Simulators" window (Shift-Cmd-2) and confirm your device is connected. If not, connect it via cable.
7. Product > Run.

And we are ready to go.
## How to use it
The app has 3 screens:
### History
Responsible for showing past inferences as well as provinding some basic statistics of your inference history.
### Main (Coremelysis)
The core of the app, here you can type your entries and have then be evaluated and stored in the history. 
### Settings
Here you can change the model used for inference (see the list bellow for options) as well as see more information on the app.

| Model | Author | Source |
| -------- | -------- | -------- |
| Natural Language | Apple | [Link](https://developer.apple.com/documentation/naturallanguage) |
| Sentiment Polarity | Vadym Markov | [Link](https://github.com/cocoa-ai/SentimentCoreMLDemo/blob/master/README.md#model) |


## Our Motivation
This is a final project for college from 2 CS majors. 
Our goal was to create a privacy focused and AI powered mobile solution for experience sampling (or ecological momentary assessment).
