//
//  TodayViewController.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/10/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit
import CoreLocation

class TodayViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var noLocationSign: NoLocationAccessView!
    @IBOutlet weak var loadingSign: UIActivityIndicatorView!
    @IBOutlet weak var weatherNotLoadedSign: NoDataView!
    var locationManager: CLLocationManager!
    var location: CLLocation!
    var todayWeather: TodayWeather!

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
            noLocationSign.isHidden = false
            loadingSign.isHidden = true
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            print("got permisson")
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
                print(self.todayWeather!)
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
    
    @IBAction func share() {
       if let link = NSURL(string: "https://openweathermap.org") {
           let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
           self.present(activityVC, animated: true, completion: nil)
       }
    }

}
