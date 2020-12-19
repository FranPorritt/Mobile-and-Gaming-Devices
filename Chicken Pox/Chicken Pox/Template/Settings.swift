//
//  Settings.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 15/11/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import SpriteKit

enum PhysicsCategories
{
    static let none: UInt32 = 0
    static let enemyCategory: UInt32 = 0x1          
    static let playerCategory: UInt32 = 0x2
    static let projectileCategory: UInt32 = 0x4
    static let boundaryCategory: UInt32 = 0x8
    static let powerCategory: UInt32 = 0x16
}
