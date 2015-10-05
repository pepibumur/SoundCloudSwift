//
//  StorableError.swift
//  SoundCloudSwift
//
//  Created by Pedro Pinera Buendia on 05/10/15.
//  Copyright © 2015 SugarTeam. All rights reserved.
//

import Foundation

/**
*  Errors thrown by the Storable protocol
*/
public enum StorableError: ErrorType {
    case InvalidData(String)
}