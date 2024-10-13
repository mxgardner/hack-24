# Hack-24: Panic Attack Detection and Alert System

## Overview

**Hack-24** is a mobile application that integrates with an Arduino-based sensor system to monitor heart rate and detect signs of panic attacks. Upon detecting abnormal heart rate patterns, the app sends a WhatsApp message to a pre-saved contact to notify them of the situation. The app also triggers push notifications for the user to check on their condition.

## Features

- **Heart Rate Monitoring**: Collects real-time heart rate data using an Arduino sensor.
- **Panic Detection**: Alerts are sent when the heart rate exceeds a panic threshold.
- **WhatsApp Notification**: Automatically sends a WhatsApp message to a designated contact if a panic attack is detected.
- **Push Notifications**: Triggers in-app notifications to remind users to check their condition.
- **User Interface**: Easy-to-use interface to enter contact details, start monitoring, and receive alerts.

## Technology Stack

- **iOS**: Swift, UIKit, UserNotifications
- **Arduino**: C++ for heart rate sensor integration
- **Twilio API**: For sending WhatsApp messages
- **Ngrok**: Tunnel API calls to local development server
- **HealthKit**: To track heart rate data (if connected with Apple Health)
- **Adafruit Bluefruit Feather**: Arduino-compatible board for hardware monitoring

## Installation

### 1. Clone the repository

git clone https://github.com/mxgardner/hack-24.git

Push to the branch: git push origin my-feature.
Submit a pull request.
License
This project is licensed under the MIT License - see the LICENSE file for details.

### 2. iOS App Setup
- Open the Xcode project in the `/hack-app` folder.
- Make sure to link the required frameworks: `UserNotifications`, `HealthKit`, and `ORSSerial`.
- Add `NSHealthShareUsageDescription` to `Info.plist` to request HealthKit authorization.

### 3. Arduino Setup
- Upload the Arduino code from the `/arduino-code` folder to the Adafruit Bluefruit Feather board.
- Connect the heart rate sensor to the Feather board.
- Ensure that the baud rate for serial communication is set to 9600.

### 4. Twilio Setup
- Set up a [Twilio account](https://www.twilio.com/) and configure a WhatsApp sandbox.
- Update your Twilio `Account SID`, `Auth Token`, and `From` number in the server code.

### 5. Ngrok Setup
- Install [ngrok](https://ngrok.com/) and set up a tunnel to expose your local server to the internet:bash
ngrok http 3000

### Usage

1. **Arduino Setup**
   - Connect the sensor to the Arduino board.
   - Upload the provided code for heart rate monitoring.

2. **Run the iOS App**
   - Open the app on your iOS device.
   - Enter the WhatsApp number for notifications.
   - Start monitoring for panic attack symptoms.

3. **WhatsApp Alerts**
   - The app will send WhatsApp messages if panic attack symptoms are detected.

4. **Push Notifications**
   - Push notifications will remind users to check on their heart rate and condition.
### Hardware

The project utilizes the **Adafruit Bluefruit Feather** for real-time heart rate monitoring via sensors. Ensure that the hardware connections between the Feather board and the sensors are secure.

**Components:**
- Adafruit Bluefruit Feather
- Heart rate sensor (connected to analog pin)
- LEDs for normal/panic status indicators

### App UI

The app features a sleek, user-friendly interface with:
- Input fields to save WhatsApp numbers.
- A button to trigger real-time WhatsApp messages when panic symptoms are detected.
- Push notification functionality to alert the user.

### Contributing

We welcome contributions from the community. To contribute:
1. Fork this repository.
2. Create a new branch: `git checkout -b my-feature`.
3. Make your changes.
4. Commit them: `git commit -am 'Add some feature'`.
5. Push to the branch: `git push origin my-feature`.
6. Submit a pull request.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
