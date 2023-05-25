//
//  NSAttributedString+JK.swift
//  JKSteppedProgressBar
//
//  Created by Jayahari Vavachan on 6/12/18.
//

import Foundation
import UIKit

extension NSAttributedString {
    func draw(center: CGPoint) {
        var rect = self.boundingRect(with: CGSize(width: 1000, height: 1000),
                                     options: [.usesFontLeading, .usesLineFragmentOrigin],
                                     context: nil)
        let size = rect.size
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        rect.origin = origin
        self.draw(in: rect)
    }
}

public extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        leftCopy.append(right)
        return leftCopy
    }

    static func + (left: NSAttributedString, right: String) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        let rightAttr = NSMutableAttributedString(string: right)
        leftCopy.append(rightAttr)
        return leftCopy
    }

    static func + (left: String, right: NSAttributedString) -> NSAttributedString {
        let leftAttr = NSMutableAttributedString(string: left)
        leftAttr.append(right)
        return leftAttr
    }
}
