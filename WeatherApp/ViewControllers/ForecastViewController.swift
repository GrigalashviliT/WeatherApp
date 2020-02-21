//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/10/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController, CLLocationManagerDelegate, ControllingProtocol {
    
    @IBOutlet weak var refreshButton : UIBarButtonItem!
    @IBOutlet weak var loadingSign: UIActivityIndicatorView!
    @IBOutlet weak var locationDeniedSign: LocationDeniedView!
    @IBOutlet weak var noLocationSign: NoLocationView!
    @IBOutlet weak var weatherNotLoadedSign: NoDataView!
    @IBOutlet weak var forecastInfoView: FiveDaysForecastView!
    var locationManager: CLLocationManager!
    var location: CLLocation!
    var forecast: Forecast!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherNotLoadedSign.delegate = self
        noLocationSign.delegate = self
        
        loadingSign.isHidden = true
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        refreshingInfo()
        updateLocation()
    }
    
    private func updateLocation() {
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied){
            locationNotSupportedOrNonAccessable()
        }
        
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
                updateWeather()
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
                DispatchQueue.main.async {
                    self.forecastInfoView.fill(forecasts: self.forecast.list)
                    self.infoLoaded()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorWhileLoadingWeather()
                }
            }
        })

        task.resume()
    }
    
    private func locationNotSupportedOrNonAccessable() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = false
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = true
        forecastInfoView.isHidden = true
        
        refreshButton.isEnabled = false
    }
    
    private func errorWhileLoadingLocation() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = false
        weatherNotLoadedSign.isHidden = true
        forecastInfoView.isHidden = true
        
        refreshButton.isEnabled = false
    }
    
    private func errorWhileLoadingWeather() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = false
        forecastInfoView.isHidden = true
        
        refreshButton.isEnabled = true
    }
    
    private func refreshingInfo() {
        loadingSign.isHidden = false
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = true
        forecastInfoView.isHidden = true
        
        refreshButton.isEnabled = true
    }
    
    private func infoLoaded() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = true
        forecastInfoView.isHidden = false
        
        refreshButton.isEnabled = true
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
        updateLocation()
    }

}

