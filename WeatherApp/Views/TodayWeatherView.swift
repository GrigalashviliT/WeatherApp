//
//  TodayWeatherView.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/16/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit

class TodayWeatherView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var cloudiness: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDirection: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TodayWeatherView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.isHidden = true
    }
    
    func fill(todayWeather: TodayWeather, imageData: Data) {
        image.image = UIImage(data: imageData)
        location.text = todayWeather.name + ", " + todayWeather.sys.country
        weather.text = "\(todayWeather.main.tempMin)°C | " + todayWeather.weather.first!.main
        cloudiness.text = "\(todayWeather.clouds.all) %"
        humidity.text = "\(todayWeather.main.humidity) mm"
        pressure.text = "\(todayWeather.main.pressure) hPa"
        windSpeed.text = "\(todayWeather.wind.speed) km/h"
        windDirection.text = "\(todayWeather.windDirection())"
    }

}
