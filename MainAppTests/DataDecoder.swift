//
//  DataDecoder.swift
//  MainAppTests
//
//  Created by Mr Ravi on 05/02/24.
//

import Foundation

enum DecodingError:Error {
    case fileNotFound
    case dataInitError(Error)
    case decodingError(Error)
}

extension Decodable {
    static func decode(filename:String, bundle:Bundle = Bundle(for: MainAppTests.self)) -> Result<Self,DecodingError> {
        
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            return .failure(.fileNotFound)
        }
        
        var data:Data
        do {
            data = try Data(contentsOf: url)
        }catch {
            return .failure(.dataInitError(error))
        }
        
        do {
            let result = try JSONDecoder().decode(self, from: data)
            return .success(result)
        }catch {
            return .failure(.decodingError(error))
        }
    }
}
