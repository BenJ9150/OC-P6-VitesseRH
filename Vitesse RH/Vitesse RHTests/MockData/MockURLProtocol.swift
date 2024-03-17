//
//  MockURLProtocol.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import Foundation

class MockURLProtocol: URLProtocol {

    // Handler to test the request and return mock response.
    static var requestHandler: (() throws -> (urlResponse: HTTPURLResponse, data: Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        // To check if this protocol can handle the given request.
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Here you return the canonical version of the request but most of the time you pass the orignal one.
        return request
    }

    override func startLoading() {
        // Request handler
        guard let handler = MockURLProtocol.requestHandler else {
            // Send urlResponse to the client (to test urlResponse as? HTTPURLResponse error)
            client?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: .notAllowed)
            // Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        do {
            // Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler()

            // Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
                // Send received data to the client.
                client?.urlProtocol(self, didLoad: data)
            }

            // Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // This is called if the request gets canceled or completed.
    }
}
