//
//  Location.swift
//  ToDoApp
//
//  Created by Denis Larin on 18.01.2021.
//

import Foundation
import CoreLocation

struct Location {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
}
// lhs and rhs - left/right hand side
extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        guard rhs.coordinate?.latitude == lhs.coordinate?.latitude && lhs.coordinate?.longitude == rhs.coordinate?.latitude && lhs.name == rhs.name
        else { return false }
        return true
    }
}
