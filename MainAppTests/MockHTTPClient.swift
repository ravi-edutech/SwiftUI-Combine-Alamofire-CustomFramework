//
//  MockHTTPClient.swift
//  MainAppTests
//
//  Created by Mr Ravi on 05/02/24.
//

import Foundation
@testable import FindMyIPFramework
import Combine

class MockHTTPClient:HTTPClientProtocol {
    
    var handleFailure = false
    
    func fetch<T>(url: URL) -> AnyPublisher<T, NetworkingError> where T : Decodable, T : Encodable {
        if handleFailure {
            return handleFailureCase(errorMessage: "there is some network error")
        }else {
            
            let result = T.decode(filename: "MockIPAddress")
            
            switch result {
            case .success(let result):
                return handleSuccessCase(value: result)
            case .failure(let error):
                return handleFailureCase(errorMessage: error.localizedDescription)
            }
        }
    }
    
    private func handleSuccessCase<T>(value:T) -> AnyPublisher<T, NetworkingError> where T : Decodable, T : Encodable {
        let publisher = CurrentValueSubject<T, NetworkingError>(value)
        return publisher.eraseToAnyPublisher()
    }
    
    
    private func handleFailureCase<T>(errorMessage:String) -> AnyPublisher<T, NetworkingError> where T : Decodable, T : Encodable {
        let publisher = PassthroughSubject<T, NetworkingError>()
        publisher.send(completion: .failure(NetworkingError(statusCode: 300, message: errorMessage)))
        publisher.send(completion: .finished)
        return publisher.eraseToAnyPublisher()
    }
    
}
