//
//  ExerciseClass.swift
//  ProjectLLC
//
//  Created by Pike on 4/27/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation

struct Exercise : Decodable {
    let type: Int
    let name: String
    let rating: Float
    let description: String
    let URL: String
}
