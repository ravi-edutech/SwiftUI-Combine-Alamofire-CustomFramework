//
//  MainAppTests.swift
//  MainAppTests
//
//  Created by Mr Ravi on 05/02/24.
//

import XCTest
@testable import FindMyIPFramework
import Combine

final class MainAppTests: XCTestCase {

    var mockClient:MockHTTPClient!
    var viewmodel: IPAddressViewModel!
    var cancelable: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        
        mockClient = MockHTTPClient()
        viewmodel = IPAddressViewModel(httpClient: mockClient)
        cancelable = Set()
        
    }

    func testHandleSuccessRequest(){
        let expectation = XCTestExpectation(description: "Success Case")
        
        viewmodel.$ipaddress
            .sink { value in
                if value != nil {
                    XCTAssertEqual(value?.ip, "103.183.33.102")
                    expectation.fulfill()
                }
            }
            .store(in: &cancelable)
        
        viewmodel.fetchIPAddressData()
        
        wait(for: [expectation],timeout: 1)
        
    }
    
    func testHandleFailureRequest(){
        let expectation = XCTestExpectation(description: "Failure Case")
        
        viewmodel.$errorMessage
            .sink { value in
                if !value.isEmpty {
                    XCTAssertEqual(value, "there is some network error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancelable)
        
        mockClient.handleFailure = true
        viewmodel.fetchIPAddressData()
        
        wait(for: [expectation],timeout: 1)
        
    }
    
    override func tearDownWithError() throws {
        mockClient = nil
        viewmodel = nil
        cancelable = nil
    }

}
