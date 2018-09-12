//
//  AddNewsSourceError.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 19.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

enum AddNewsSourceError: Error {
    case noLink
    case invalidLink(String)
    case newsSourceExists
    case unknownError
}
