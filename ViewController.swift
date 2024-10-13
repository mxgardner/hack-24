import UIKit
import HealthKit

class ViewController: UIViewController {
    let healthStore = HKHealthStore()
    var heartRateSamples: [HKQuantitySample] = []
    var processingIndex = 0
    var timer: Timer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
    }

    func requestAuthorization() {
        if HKHealthStore.isHealthDataAvailable() {
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let dataTypes: Set = [heartRateType]

            healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) in
                if success {
                    print("Authorization granted!")
                    self.startHeartRateQuery()
                } else {
                    print("Authorization denied: \(String(describing: error))")
                }
            }
        }
    }

    // Function to start querying heart rate data
    func startHeartRateQuery() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!

        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, newAnchor, error) in
            if let newSamples = samples as? [HKQuantitySample] {
                self.heartRateSamples.append(contentsOf: newSamples)
                print("Heart Rate Samples Collected: \(self.heartRateSamples.count)")
                
                // log samples to verify we have collected them
                for sample in newSamples {
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    print("Collected Heart Rate: \(heartRate) bpm")
                }

                // chek if any samples were actually collected
                if self.heartRateSamples.isEmpty {
                    print("No heart rate samples found.")
                } else {
                    // start processing the heart rate samples
                    self.startProcessingHeartRateSamples()
                }
            } else {
                print("Error collecting heart rate samples: \(String(describing: error))")
            }
        }

        query.updateHandler = { (query, samples, deletedObjects, newAnchor, error) in
            if let newSamples = samples as? [HKQuantitySample] {
                self.heartRateSamples.append(contentsOf: newSamples)
            }
        }

        healthStore.execute(query)
    }

    // process heart rate samples every 1/8th of a second
    func startProcessingHeartRateSamples() {
        //get rid of existing timers
        timer?.invalidate()

        // check if there are samples to process
        if heartRateSamples.isEmpty {
            print("No heart rate samples to process.")
            return
        }

        print("Starting to process heart rate samples...")

        // change value for how many times it should run per second
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.processNextHeartRateSample), userInfo: nil, repeats: true)
        }
    }

    //processes one heart rate sample at a time
    @objc func processNextHeartRateSample() {
        //  check if the timer is working
        //print("Timer tick, processing index: \(processingIndex)")
        
        // if all data is processed, stop timer
        if processingIndex >= heartRateSamples.count {
            print("All heart rate samples processed.")
            timer?.invalidate()
            return
        }

        // get the next heart rate sample
        let sample = heartRateSamples[processingIndex]

        // get the heart rate value in bpm
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let heartRate = sample.quantity.doubleValue(for: heartRateUnit)

        // output the heart rate value as it gets processed
        print("Heart Rate: \(heartRate) bpm")
        //print("index: \(processingIndex)")

        // check if heart rate exceeds threshold amount
        if heartRate > 100 {
            print("Panic at \(heartRate) bpm!")
        }

        // increment the index
        processingIndex += 1
    }
}



//GETS ALL PAST DATA ----------------------------------------
/*
import UIKit
import HealthKit

class ViewController: UIViewController {
    
    // Create a reference to HealthKit's store
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request authorization to access heart rate data
        requestAuthorization()
    }
    
    // Function to request HealthKit authorization
    func requestAuthorization() {
        if HKHealthStore.isHealthDataAvailable() {
            // Define the type of data we want to access (heart rate)
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let dataTypes: Set = [heartRateType]
            
            // Request authorization to read the heart rate data
            healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) in
                if success {
                    print("Authorization granted!")
                    // Start querying heart rate data
                    self.startHeartRateQuery()
                } else {
                    print("Authorization denied: \(String(describing: error))")
                }
            }
        }
    }
    
    // Function to start querying heart rate data
    func startHeartRateQuery() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        // Create a query that will listen for new heart rate samples
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, newAnchor, error) in
            self.processHeartRateSamples(samples)
        }
        
        // Set up a handler that triggers whenever there are new heart rate samples
        query.updateHandler = { (query, samples, deletedObjects, newAnchor, error) in
            self.processHeartRateSamples(samples)
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    // Function to process heart rate samples
    func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }
        
        // Loop through each sample
        for sample in samples {
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
            print("Heart Rate: \(heartRate) bpm")
            
            // Check if heart rate exceeds threshold
            if heartRate > 100 {  // Example threshold
                print("panic")
            }
        }
    }
}
*/
