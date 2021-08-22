//
//  KeyCenter.swift
//  Bbang
//
//  Created by 소영 on 2021/08/07.
//

import Alamofire

struct KeyCenter {
    static var TOKEN = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyIiwiZXhwIjoxNjMxMDI1MDE3LCJ1c2VySWQiOiI2MGU4MzMzN2Q5ZmU3NDU2ODUzNzViYTQifQ.zA8Jtznm5gdUMvaQA-nQbtV0ZWc_6owcxGWFYWrOHxa8YA8LslvlQslbVXw1s8eSZokwpxTCQ1XTB9qGwf1L9w"
    
    static let header: HTTPHeaders = ["Authorization": "\(KeyCenter.TOKEN)"]
}
