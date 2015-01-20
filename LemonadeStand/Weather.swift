//
//  Weather.swift
//  LemonadeStand
//
//  Created by Joshua Robins on 1/20/15.
//  Copyright (c) 2015 Pawswin. All rights reserved.
//

import Foundation
import UIKit

class Weather {
    var weatherImage = UIImage(named: "Warm")
    
    func whatIsTodaysWeather() -> String {
        var randomNumber = Int(arc4random_uniform(UInt32(3)))
        
        switch randomNumber+1 {
        case 1:
            return "Cold"
        case 2:
            return "Mild"
        default:
            return "Warm"
        }
        
    }
}