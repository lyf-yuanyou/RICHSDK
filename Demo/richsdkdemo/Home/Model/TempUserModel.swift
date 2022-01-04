//
//  TempUserModel.swift
//  richdemo
//
//  Created by Apple on 4/3/21.
//

import Foundation
import HandyJSON

/**
 测试模型
 {
   "code": 0,
   "msg": "success",
   "data": {
       "name": "Apple",
       "age": 12,
       "list": [
           {"name": "Apple", "age": 12},
           {"name": "tom", "age": 20}
       ]
   }
 }
 */
struct TempUserModel: HandyJSON {
    
    var name: String = ""
    var age: Int = 0
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            name <-- "name"
        mapper <<<
            age <-- "age"
    }
}
