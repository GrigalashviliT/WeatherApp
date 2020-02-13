//
//  NoDataView.swift
//  WeatherApp
//
//  Created by Tornike Grigalashvili on 2/13/20.
//  Copyright © 2020 Tornike Grigalashvili. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    
    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.isHidden = true
    }
    
}
