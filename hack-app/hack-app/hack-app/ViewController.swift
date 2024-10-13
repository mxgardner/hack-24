//
//  ViewController.swift
//  hack-app
//
//  Created by Mariah Jade Gardner on 10/12/24.
//

import UIKit
import UserNotifications
import ORSSerial

class ViewController: UIViewController, UNUserNotificationCenterDelegate, ORSSerialPortDelegate {
    
    @IBOutlet weak var sillyButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var pushButton: UIButton!
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
            showMessageAlert(title: "Error", message: "No phone number available")
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
            DispatchQueue.main.async {
                if let error = error {
                print("Error sending WhatsApp message: \(error.localizedDescription)")
                self.showMessageAlert(title: "Error", message: "Failed to send WhatsApp message.")
                return
                }
                    
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("WhatsApp message sent successfully")
                    self.showMessageAlert(title: "Success", message: "WhatsApp message sent!")
                } else {
                    print("Failed to send WhatsApp message")
                    self.showMessageAlert(title: "Error", message: "Failed to send WhatsApp message.")
                }
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
    // Function to show an alert when message sent
    func showMessageAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Show notification while app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound]) // Show banner and play sound even if app is in foreground
    }
    
    // Function to dismiss the keyboard when tapping outside the text field
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Load saved phone number if available
        if let savedPhoneNumber = UserDefaults.standard.string(forKey: "savedWhatsAppNumber") {
                phoneNumberTextField.text = savedPhoneNumber
        }
        
        // Add gradient background
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.view.bounds
            gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemIndigo.cgColor]
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add Button Stylings
        saveButton.layer.cornerRadius = 10
        saveButton.layer.masksToBounds = true
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveButton.layer.shadowOpacity = 0.3
        saveButton.layer.shadowRadius = 4
        
        // Add Button Stylings
        sendButton.layer.cornerRadius = 10
        sendButton.layer.masksToBounds = true
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        sendButton.layer.shadowOpacity = 0.3
        sendButton.layer.shadowRadius = 4
        
        // Add Button Stylings
        pushButton.layer.cornerRadius = 10
        pushButton.layer.masksToBounds = true
        pushButton.layer.shadowColor = UIColor.black.cgColor
        pushButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        pushButton.layer.shadowOpacity = 0.3
        pushButton.layer.shadowRadius = 4
        
        // Style phone number text field
        phoneNumberTextField.placeholder = "Enter your phone number"
        phoneNumberTextField.backgroundColor = UIColor.white
        phoneNumberTextField.textColor = UIColor.black
        phoneNumberTextField.layer.borderWidth = 0
        phoneNumberTextField.layer.cornerRadius = 10

        // Ensure the shadow is not clipped by the bounds
        phoneNumberTextField.layer.masksToBounds = false

        // Add shadow to the UITextField
        phoneNumberTextField.layer.shadowColor = UIColor.black.cgColor // Shadow color
        phoneNumberTextField.layer.shadowOpacity = 0.3 // Shadow opacity
        phoneNumberTextField.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset (position)
        phoneNumberTextField.layer.shadowRadius = 4 // Shadow blur radius
        
        let sillyIcon = UIImage(systemName: "tortoise.fill")
        sillyButton.setImage(sillyIcon, for: .normal)
        sillyButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        // Request notification permissions when the app launches
        requestNotficicationPermissions()
            
        // Set the notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
}
