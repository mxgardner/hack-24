//
//  ViewController.swift
//  hack-app
//
//  Created by Mariah Jade Gardner on 10/12/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
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
        sendWhatsAppMessage(phoneNumber: nil, message: message)
    }
    
    // Action for the "Send Notification" button
    @IBAction func sendNotificationButtonTapped(_ sender: UIButton) {
        dispathNotification()
    }
    
    // MARK: - WhatsApp Message Sending
    func sendWhatsAppMessage(phoneNumber: String?, message: String) {
        let phoneNumberToUse = phoneNumber ?? UserDefaults.standard.string(forKey: "savedWhatsAppNumber")
        
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
    
    // MARK: - Push Notification
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
    
    // Function to dismiss the keyboard when tapping outside the text field
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Request Notification Permissions
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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load saved phone number if available
        if let savedPhoneNumber = UserDefaults.standard.string(forKey: "savedWhatsAppNumber") {
            phoneNumberTextField.text = savedPhoneNumber
        }
        
        // Add gradient background and style UI elements
        configureUI()
        
        // Request notification permissions when the app launches
        requestNotficicationPermissions()
        
        // Set the notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Dismiss the keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UI Configuration
    func configureUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemIndigo.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        styleButton(saveButton)
        styleButton(sendButton)
        styleButton(pushButton)
        
        phoneNumberTextField.placeholder = "Enter your phone number"
        phoneNumberTextField.backgroundColor = UIColor.white
        phoneNumberTextField.textColor = UIColor.black
        phoneNumberTextField.layer.cornerRadius = 10
        phoneNumberTextField.layer.shadowColor = UIColor.black.cgColor
        phoneNumberTextField.layer.shadowOpacity = 0.3
        phoneNumberTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        phoneNumberTextField.layer.shadowRadius = 4
    }
    
    func styleButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
    }
}
