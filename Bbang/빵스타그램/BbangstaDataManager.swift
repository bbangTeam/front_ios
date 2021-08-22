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
    
    // 빵스타그램 좋아요
    func bbangstaLike(_ isLiked: Bool, storeId: String, delegate: BbangstaCollectionViewCell) {
        let url = "\(Constant.BASE_URL)breadstagram/like?like=\(isLiked)&id=\(storeId)"
        
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: KeyCenter.header)
            .validate()
            .responseDecodable(of: BbangstaListResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.bbangstaLike(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    // 댓글 목록 조회
    func bbangstaCommentList(id: String, page: Int, delegate: BbangstaCommentViewController) {
        let url = "\(Constant.BASE_URL)comment/list?id=\(id)&pageNum=\(page)&pageSize=5"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: KeyCenter.header)
            .validate()
            .responseDecodable(of: BbangstaCommentResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.bbangstaCommentList(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    // 댓글 작성
    func bbangstaCommentWrite(_ parameters: BbangstaCommentWriteRequest, delegate: BbangstaCommentViewController) {
        let url = "\(Constant.BASE_URL)comment/write"
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: KeyCenter.header)
            .validate()
            .responseDecodable(of: BbangstaCommentWriteResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.bbangstaCommentWrite(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
    
    // 댓글 갯수 확인
    func bbangstaCommentNumber(id: String, delegate: BbangstaCollectionViewCell) {
        let url = "\(Constant.BASE_URL)comment/count?id=\(id)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: KeyCenter.header)
            .validate()
            .responseDecodable(of: BbangstaCommentNumberResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.bbangstaCommentNumber(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
}
