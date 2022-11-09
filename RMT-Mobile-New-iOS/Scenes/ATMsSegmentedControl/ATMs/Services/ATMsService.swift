//
//  ATMsService.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 15.09.22.
//

import Foundation
import Moya

enum ATMsService {
    case getDepartmants
    case getOneDepartment(id: String)
}

extension ATMsService: TargetType {
    private enum ServiceKeys {
        static let baseURL = "http://10.10.15.217:9769/bank-info/api/v1"
        static let currentDepartments = "/departments"
    }
    
    private enum ParserKeys {
        static let departmentParameter = "id"
    }

    var baseURL: URL { return URL(string: ServiceKeys.baseURL)! }
    
    var path: String {
        return ServiceKeys.currentDepartments
    }
    
    var method: Moya.Method {
        switch self {
        case .getDepartmants:
            return .get
        case .getOneDepartment(id: ):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getDepartmants:
            return .requestPlain
        case .getOneDepartment(let id):
            return .requestParameters(parameters: [ParserKeys.departmentParameter : id], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
