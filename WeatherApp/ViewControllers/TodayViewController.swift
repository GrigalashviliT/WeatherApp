//
//  TodayViewController.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/10/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit
import CoreLocation

class TodayViewController: UIViewController, CLLocationManagerDelegate, ControllingProtocol {
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var loadingSign: UIActivityIndicatorView!
    @IBOutlet weak var locationDeniedSign: LocationDeniedView!
    @IBOutlet weak var noLocationSign: NoLocationView!
    @IBOutlet weak var weatherNotLoadedSign: NoDataView!
    var locationManager: CLLocationManager!
    var location: CLLocation!
    var todayWeather: TodayWeather!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherNotLoadedSign.delegate = self
        noLocationSign.delegate = self
        
        noLocationSign.isHidden = true
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        refreshingInfo()
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
        locationManager.stopUpdatingLocation()
        
        if let loc = locations.first {
            if(self.location == nil){
                self.location = loc
                let weatherLoaded = updateWeather()
                if(weatherLoaded) {
                    infoLoaded()
                } else {
                    errorWhileLoadingWeather()
                }
            }
        } else {
            errorWhileLoadingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            locationNotSupportedOrNonAccessable()
        }
    }
    
    private func updateWeather() -> Bool {
        var success = true
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=1868b8202cdf01a3a646241316dbd62b&units=metric"
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                self.todayWeather = try decoder.decode(TodayWeather.self, from: data!)
                print(self.todayWeather!)
            } catch {
                success = false
            }
        })

        task.resume()
        return success
    }
    
    private func locationNotSupportedOrNonAccessable() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = false
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = true
        
        refreshButton.isEnabled = false
        shareButton.isEnabled = false
    }
    
    private func errorWhileLoadingLocation() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = false
        weatherNotLoadedSign.isHidden = true
        
        refreshButton.isEnabled = false
        shareButton.isEnabled = false
    }
    
    private func errorWhileLoadingWeather() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = false
        
        refreshButton.isEnabled = true
        shareButton.isEnabled = false
    }
    
    private func refreshingInfo() {
        loadingSign.isHidden = false
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = true
        
        refreshButton.isEnabled = true
        shareButton.isEnabled = false
    }
    
    private func infoLoaded() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = true
        
        refreshButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    func refreshWeather() {
        refresh()
    }
    
    func requireLocation() {
        refreshingInfo()
        location = nil
        updateLocation()
    }
    
    @IBAction func refresh() {
        refreshingInfo()
        location = nil
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func share() {
       if let link = NSURL(string: "https://openweathermap.org") {
           let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
           self.present(activityVC, animated: true, completion: nil)
       }
    }

}
