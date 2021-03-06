//
//  Message.swift
//  Quertie
//
//  Created by Edward Theodor on 02/02/2019.
//  Copyright © 2019 Edward Theodor. All rights reserved.
//

import Foundation
import UIKit
import MessageKit


struct Member {
    let name : String
    let color : UIColor
}


struct Message {
    let member : Member
    let text : String
    let messageId : String
    
    
}

extension Message : MessageType {
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }

    
}


extension Member {
    var toJSON: Any {
        return [
            "name": name,
            "color": color.hexString
        ]
    }
    
    init?(fromJSON json: Any) {
        guard
            let data = json as? [String: Any],
            let name = data["name"] as? String,
            let hexColor = data["color"] as? String
            else {
                print("Couldn't parse Member")
                return nil
        }
        
        self.name = name
        self.color = UIColor(hex: hexColor)
    }
}
