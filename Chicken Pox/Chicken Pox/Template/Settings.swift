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
    static let enemyCategory: UInt32 = 1
    static let playerCategory: UInt32 = 2
    static let projectileCategory: UInt32 = 4
    static let boundaryCategory: UInt32 = 8
    static let friendCategory: UInt32 = 16
    static let invincibleCategory: UInt32 = 32
}
