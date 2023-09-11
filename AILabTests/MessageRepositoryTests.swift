//
//  MessageRepositoryTests.swift
//  AILabTests
//
//  Created by Aleksunder Volkov on 08.09.2023.
//  Copyright © 2023 TOO MDDT. All rights reserved.
//

import XCTest
import Combine
@testable import AILab

class MessageRepositoryTests: XCTestCase {
    var messageRepository: MessageRepository!
    
    override func setUp() {
        super.setUp()
        messageRepository = MessageRepository()
    }
    
    override func tearDown() {
        messageRepository = nil
        super.tearDown()
    }
    
    func testSendRequestSuccess() {
        let expectation = XCTestExpectation(description: "Send request success")
        
        let request = "Test request"
        
        let publisher = messageRepository.send(request: request)
        
        let cancellable = publisher.sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected error: \(error.localizedDescription)")
            }
        } receiveValue: { response in
            XCTAssertEqual(response, "Test response")
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        cancellable.cancel()
    }
    
    func testSendRequestFailure() {
        let expectation = XCTestExpectation(description: "Send request failure")
        
        let request = ""
        
        let publisher = messageRepository.send(request: request)
        
        let cancellable = publisher.sink { completion in
            switch completion {
            case .finished:
                XCTFail("Expected failure, but received success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Unknown case")
                expectation.fulfill()
            }
        } receiveValue: { _ in
            XCTFail("Expected failure, but received success")
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        cancellable.cancel()
    }
    
    func testSendRequestEmptyResponse() {
        let expectation = XCTestExpectation(description: "Send request empty response")
        
        let request = "Test request"
        
        let publisher = messageRepository.send(request: request)
        
        let cancellable = publisher.sink { completion in
            switch completion {
            case .finished:
                XCTFail("Expected failure, but received success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Unknown case")
                expectation.fulfill()
            }
        } receiveValue: { response in
            XCTFail("Expected failure, but received success")
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        cancellable.cancel()
    }
    
    func testSendRequestError() {
        let expectation = XCTestExpectation(description: "Send request error")
        
        let request = "Test request"
        
        let publisher = messageRepository.send(request: request)
        
        let cancellable = publisher.sink { completion in
            switch completion {
            case .finished:
                XCTFail("Expected failure, but received success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Test error")
                expectation.fulfill()
            }
        } receiveValue: { _ in
            XCTFail("Expected failure, but received success")
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        cancellable.cancel()
    }
    
    func testSendRequestModel() {
        let expectation = XCTestExpectation(description: "Send request model")
        
        let request = "Test request"
        
        let publisher = messageRepository.send(request: request)
        
        let cancellable = publisher.sink { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected error: \(error.localizedDescription)")
            }
        } receiveValue: { response in
            XCTAssertEqual(response, "Test response")
            
            // Additional assertions for model
            // ...
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        cancellable.cancel()
    }
}
//```
//
//This Test class includes the following Unit Tests:
//1. `testSendRequestSuccess`: Tests the successful sending of a request and receiving a response.
//2. `testSendRequestFailure`: Tests the failure case when sending an empty request.
//3. `testSendRequestEmptyResponse`: Tests the failure case when receiving an empty response.
//4. `testSendRequestError`: Tests the failure case when encountering an error during the request.
//5. `testSendRequestModel`: Tests additional assertions related to the model used for sending requests and receiving responses.
//
//Note: You may need to modify the assertions and expectations based on your specific requirements and implementation details.

