//
//  NSWindow+Extension.swift
//  Pasty
//
//  Created by Federico Vitale on 22/05/2019.
//  Copyright © 2019 Federico Vitale. All rights reserved.
//

import Foundation
import AppKit

extension NSWindow.StyleMask {
    mutating
    func removeMultiple(_ members: NSWindow.StyleMask...) -> Void {
        for member in members {
            let _ = remove(member)
        }
    }
}
