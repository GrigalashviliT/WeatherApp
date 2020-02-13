//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/10/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var refreshButton : UIButton!
    @IBOutlet weak var noLocatonSign: NoLocationAccessView!
    @IBOutlet weak var loadingSign: UIActivityIndicatorView!
    @IBOutlet weak var weatherNotLoadedSign: NoDataView!
    var locationManager: CLLocationManager!
    var location: CLLocation!
    var forecast: Forecast!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        updateLocation()
    }
    
    private func updateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            if(self.location == nil){
                self.location = loc
                locationManager.stopUpdatingLocation()
                updateWeather()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            noLocatonSign.isHidden = false
            loadingSign.isHidden = true
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            print("got permission")
        }
    }
    
    private func updateWeather() {
        let path = "http://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=1868b8202cdf01a3a646241316dbd62b&units=metric"
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                self.forecast = try decoder.decode(Forecast.self, from: data!)
                print(self.forecast!)
            } catch {
                self.weatherNotLoadedSign.isHidden = false
            }
        })

        task.resume()
    }
    
    @IBAction func refresh() {
        self.location = nil
        locationManager.startUpdatingLocation()
    }

}

