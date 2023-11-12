//
//  TrackerEntity.swift
//  MileageTracker
//
//  Created by Brian Nguyen on 6/29/23.
//

import UIKit
import CoreData

class TrackerEntity: NSObject {
    var fromAddress = ""
    var toAddress = ""
    var dateAndTime : Date
    
    init(_ fromAddress: String,_ toAddress: String,_ dateAndTime: Date) {
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.dateAndTime = dateAndTime
    }

}
