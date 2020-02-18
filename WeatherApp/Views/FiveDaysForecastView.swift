//
//  FiveDaysForecastView.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/17/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit

class FiveDaysForecastView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var first: DailyForecastView!
    @IBOutlet weak var second: DailyForecastView!
    @IBOutlet weak var third: DailyForecastView!
    @IBOutlet weak var fourth: DailyForecastView!
    @IBOutlet weak var fifth: DailyForecastView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FiveDaysForecastView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.isHidden = true
    }
    
    func fill(forecasts: [Forecasts]) {
        first.fill(list: Array(forecasts[0..<8]))
        second.fill(list: Array(forecasts[8..<16]))
        third.fill(list: Array(forecasts[16..<24]))
        fourth.fill(list: Array(forecasts[24..<32]))
        fifth.fill(list: Array(forecasts[32..<40]))
    }

}
