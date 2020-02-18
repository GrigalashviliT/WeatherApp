//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/17/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit

class DailyForecastView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var first: HourlyWeatherView!
    @IBOutlet weak var second: HourlyWeatherView!
    @IBOutlet weak var third: HourlyWeatherView!
    @IBOutlet weak var fourth: HourlyWeatherView!
    @IBOutlet weak var fifth: HourlyWeatherView!
    @IBOutlet weak var sixth: HourlyWeatherView!
    @IBOutlet weak var seventh: HourlyWeatherView!
    @IBOutlet weak var eighth: HourlyWeatherView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DailyForecastView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func fill(list: [Forecasts]) {
        weekDay.text = getWeekDay(dateText: list[1].dtTxt)
        first.fill(forecast: list[1])
        second.fill(forecast: list[2])
        third.fill(forecast: list[3])
        fourth.fill(forecast: list[4])
        fifth.fill(forecast: list[5])
        sixth.fill(forecast: list[6])
        seventh.fill(forecast: list[7])
        eighth.fill(forecast: list[0])
    }
    
    func getWeekDay(dateText: String) -> String{
        let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:dateText)!
        let weekday = Calendar.current.component(.weekday, from: date)
        
        return weekDays[weekday - 1]
    }

}
