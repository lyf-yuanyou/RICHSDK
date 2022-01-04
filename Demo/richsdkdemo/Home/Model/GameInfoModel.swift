//
//  GameInfoModel.swift
//  richdemo
//
//  Created by Apple on 5/3/21.
//

import Foundation
import HandyJSON

struct GameInfoModel: HandyJSON {
    
    var sm: [String: Any] = [:]
    var ips: [String: Any] = [:]
    var ssm: GameSSMModel?
    var psm: [String: Any] = [:]
    var tipc: Int = 0
    var tssc: Int = 0
    var tpc: Int = 0
    
    struct GameSSMModel: HandyJSON {
        
        var v: Int = 0
        var ssmd: [GameSSMDModel] = []
        
    }
    
    struct GameSSMDModel: HandyJSON {
        
        var sid: Int = 0
        var sn: String = ""
        var sen: String = ""
        var mt: Int = 0
        var son: Int = 0
        var tc: Int = 0
        var tmrc: Int = 0
        var ipc: Int = 0
        var ec: Int = 0
        var psc: Int = 0
        var orc: Int = 0
        var eec: Int = 0
        var puc: [Any] = []
        var pc: Int = 0
        
    }
    
}
