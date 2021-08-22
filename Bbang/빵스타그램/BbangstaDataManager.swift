//
//  BbangstaDataManager.swift
//  Bbang
//
//  Created by 소영 on 2021/08/07.
//

import Alamofire

class BbangstaDataManager {
    
    // 빵스타그램 조회
    func bbangstaList(page: Int, delegate: BbangstagramViewController) {
        let url = "\(Constant.BASE_URL)breadstagram/list?pageNum=\(page)&pageSize=5"
       
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: KeyCenter.header)
            .validate()
            .responseDecodable(of: BbangstaListResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if page == 0 {
                        delegate.bbangstaList(result: response)
                    } else {
                        delegate.addBbangstaList(result: response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    // 빵스타그램 이미지 조회
    func bbangstaImageList(page: Int, delegate: BbangstaCollectionViewCell) {
        let url = "\(Constant.BASE_URL)breadstagram/list?pageNum=\(page)&pageSize=2"
       
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: KeyCenter.header)
            .validate()
            .responseDecodable(of: BbangstaListResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.bbangstaImageList(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
}
