//
//  ViewController.swift
//  hack-app
//
//  Created by Mariah Jade Gardner on 10/12/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    // Action for the "Save" button
    @IBAction func saveWhatsAppButtonTapped(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTextField?.text, !phoneNumber.isEmpty else {
            print("Phone number is empty")
            return
        }
        
        // Save the phone number to UserDefaults
        UserDefaults.standard.set(phoneNumber, forKey: "savedWhatsAppNumber")
        
        // Show an alert to confirm that the number has been saved
        let alert = UIAlertController(title: "Success", message: "WhatsApp number saved!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Action for the "Send" button
    @IBAction func sendWhatsAppButtonTapped(_ sender: UIButton) {
        let message = "Hello, this is another test WhatsApp message."
        
        // Call sendWhatsAppMessage with nil, which will use the stored number
        sendWhatsAppMessage(phoneNumber: nil, message: message)
    }
    
    // Action for the "Send Notification" button
    @IBAction func sendNotificationButtonTapped(_ sender: UIButton) {
        dispathNotification()
    }
    
    func sendWhatsAppMessage(phoneNumber: String?, message: String) {
        // Try to retrieve the saved phone number from UserDefaults if the input phone number is nil
        let phoneNumberToUse = phoneNumber ?? UserDefaults.standard.string(forKey: "savedWhatsAppNumber")
        
        // Ensure a valid phone number is available
        guard let validPhoneNumber = phoneNumberToUse, !validPhoneNumber.isEmpty else {
            print("No phone number available to send WhatsApp message")
            return
        }
        
        guard let url = URL(string: "https://676a-129-107-172-10.ngrok-free.app/send-whatsapp") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "to": validPhoneNumber,
            "message": message
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending WhatsApp message: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("WhatsApp message sent successfully")
            } else {
                print("Failed to send WhatsApp message")
            }
        }
        task.resume()
    }
        
        func requestNotficicationPermissions() {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    print("Notification permissions granted.")
                } else if let error = error {
                    print("Failed to request notification permissions: \(error.localizedDescription)")
                }
            }
        }
        
        func dispathNotification() {
            let title = "You have been notified."
            let body = "This is your final warning"
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Load saved phone number if available
            if let savedPhoneNumber = UserDefaults.standard.string(forKey: "savedWhatsAppNumber") {
                phoneNumberTextField.text = savedPhoneNumber
            }
            
            // Request notification permissions when the app launches
            requestNotficicationPermissions()
        }
    }
