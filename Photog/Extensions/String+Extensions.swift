//
//  String+Extensions.swift
//  Photog
//
//  Created by One Month on 9/10/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import Foundation

extension String
{
    func isEmailAddress() -> Bool
    {
        var predicate = self.predicateForEmail()
        return predicate.evaluateWithObject(self)
    }
    
    func predicateForEmail() -> NSPredicate
    {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", regularExpression)
    }
}