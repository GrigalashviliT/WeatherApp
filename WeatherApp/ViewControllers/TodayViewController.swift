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
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var loadingSign: UIActivityIndicatorView!
    @IBOutlet weak var locationDeniedSign: LocationDeniedView!
    @IBOutlet weak var noLocationSign: NoLocationView!
    @IBOutlet weak var weatherNotLoadedSign: NoDataView!
    @IBOutlet weak var weatherInfoView: TodayWeatherView!
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
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=1868b8202cdf01a3a646241316dbd62b&units=metric"
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                self.todayWeather = try decoder.decode(TodayWeather.self, from: data!)
                self.getWeatherIcon()
            } catch {
                DispatchQueue.main.async {
                    self.errorWhileLoadingWeather()
                }
            }
        })

        task.resume()
    }
    
    private func getWeatherIcon() {
        let path = "http://openweathermap.org/img/wn/\(self.todayWeather.weather.first!.icon)@2x.png"
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                DispatchQueue.main.async {
                    self.weatherInfoView.fill(todayWeather: self.todayWeather, imageData: data!)
                    self.infoLoaded()
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
        weatherInfoView.isHidden = true
        
        refreshButton.isEnabled = false
        shareButton.isEnabled = false
    }
    
    private func errorWhileLoadingLocation() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = false
        weatherNotLoadedSign.isHidden = true
        weatherInfoView.isHidden = true
        
        refreshButton.isEnabled = false
        shareButton.isEnabled = false
    }
    
    private func errorWhileLoadingWeather() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = false
        weatherInfoView.isHidden = true
        
        refreshButton.isEnabled = true
        shareButton.isEnabled = false
    }
    
    private func refreshingInfo() {
        loadingSign.isHidden = false
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = true
        weatherInfoView.isHidden = true
        
        refreshButton.isEnabled = true
        shareButton.isEnabled = false
    }
    
    private func infoLoaded() {
        loadingSign.isHidden = true
        locationDeniedSign.isHidden = true
        noLocationSign.isHidden = true
        weatherNotLoadedSign.isHidden = true
        weatherInfoView.isHidden = false
        
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
        updateLocation()
    }
    
    @IBAction func share() {
        let weatherText = """
        Today's weather in \(todayWeather.name), \(todayWeather.sys.country):
        description: \(todayWeather.weather.first!.main)
        temperature: \(todayWeather.main.temp)°C
        max temperature: \(todayWeather.main.tempMax)°C
        min temperature: \(todayWeather.main.tempMin)°C
        cloudiness: \(todayWeather.clouds.all)%
        humidity: \(todayWeather.main.humidity)mm
        pressure: \(todayWeather.main.pressure)hPa
        wind speed: \(todayWeather.wind.speed)km/h
        wind direction: \(todayWeather.windDirection())
        """
        let activityVC = UIActivityViewController(activityItems: [weatherText], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }

}
