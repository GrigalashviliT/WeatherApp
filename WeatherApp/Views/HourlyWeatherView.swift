//
//  HourlyWeatherView.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/17/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit

class HourlyWeatherView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var temperature: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HourlyWeatherView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func fill(forecast: Forecasts) {
        getWeatherIcon(forecast: forecast)
        time.text = String(forecast.dtTxt.suffix(8).prefix(5))
        weather.text = forecast.weather.first?.description
        temperature.text = "\(Int(forecast.main.temp))°C"
    }
    
    private func getWeatherIcon(forecast: Forecasts) {
        let path = "http://openweathermap.org/img/wn/\(forecast.weather.first!.icon)@2x.png"
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data!)
                }
            }
        })

        task.resume()
    }

}
