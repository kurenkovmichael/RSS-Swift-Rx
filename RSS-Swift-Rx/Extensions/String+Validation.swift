//
//  String+Validation.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 20.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

extension String
{
    func isValidURL() -> Bool
    {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        
        return false
    }
}
