//
//  LocationManager.swift
//  calendar
//
//  Created by yuteng Lan on 2024/6/10.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationCompletionHandler: ((CLLocation?) -> Void)?
    var latitude = ""
    var longitude = ""

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation(completion: @escaping (CLLocation?) -> Void) -> CLLocation {
        locationCompletionHandler = completion
        locationManager.requestLocation()
        return locationManager.location ?? CLLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationCompletionHandler?(location)
        } else {
            locationCompletionHandler?(nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        locationCompletionHandler?(nil)
    }
}
