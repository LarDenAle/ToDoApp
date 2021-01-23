//
//  APIClientTests.swift
//  ToDoAppTests
//
//  Created by Denis Larin on 22.01.2021.
//

import XCTest
@testable import ToDoApp

class APIClientTests: XCTestCase {
    var sut: APIClient!
    var mockURLSession: MockURLSession!

    override func setUpWithError() throws {
        super.setUp()
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut = APIClient()
        sut.urlSession = mockURLSession
    }

    override func tearDownWithError() throws {
        
    }
    
    func userLogin() {
        let completionHandler = {(token: String?, error: Error?) in }
        sut.login(withName: "name", password: "%qwerty", completionHandler: completionHandler)
    }
    
    // тест - когда пользователь пытается залогинится то обращение к серверу использует правильный хост
    func test_Login_Uses_CurrectHost() {
//        let mockURLSession = MockURLSession()
//        let sut = APIClient()
//        sut.urlSession = mockURLSession
//
//        let comletionHandler = { (token: String?, error: Error? ) in }
//        sut.login(withName: "name", password: "qwerty", comletionHandler: comletionHandler)
//
//        guard let url = mockURLSession.url else {
//            XCTFail()
//            return
//        }
//
//        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
//        XCTAssertEqual(urlComponents?.host , "todoapp.com")
        
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.com")
    }
    func test_Login_Uses_CorrectPath() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    func test_Login_Uses_ExpectedQueryParameters() {
        userLogin()
        
        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
    // token -> Data ( токен вложен в дату) -> completionHandler -> DataTask -> urlSession
    //  тест на проверку что генерируется токен при успешной авторизации
    func test_SuccessFulLogin_CreatesToken() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8) // создаем токен в DataStub - объекты возвращаемые с сервера , но сервера не существует
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let tokenExpectation = expectation(description: "Token expectation") 
        
        var caughtToken: String?
        sut.login(withName: "login", password: "password") { token, _ in
            caughtToken = token // получили токен
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughtToken, "tokenString")
        }
    }
    
    func test_Login_InvalidJSON_ReturnsError() {
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _ , error in
            caughtError = error // получили токен
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    func test_Login_WhenDataIsNil_ReturnsError() {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error // получили токен
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    func test_Login_WhenResponseError_ReturnsError() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let error = NSError(domain: "Server error", code: 404, userInfo: nil)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: error)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
}
 


extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
//    class MockURLSession: URLSession {
        
        var url: URL?
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                XCTFail()
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL:  true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
//            return URLSession.shared.dataTask(with: url)
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    class MockURLSessionDataTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(
                    self.data,
                    self.urlResponse,
                    self.responseError
                )
            }
        }
    }
}
