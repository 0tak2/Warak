//
//  HTTPEndpoint.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import os.log

struct HTTPEndpoint<Body, Response> where Body: Encodable, Response: Decodable {
    let destination: String
    let headers: [String: String]?
    let queryParameters: [String: String]?
    let body: Body?
    let method: HTTPMethod
    private let logger: Logger!
    private var loggerPrefix: String {
        "Client -> \(method.rawValue) \(destination) (headers: \(String(describing: headers)), queryParameters: \(String(describing: queryParameters)), body: \(String(describing: body)))"
    }
    
    init (
        destination: String,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        body: Body? = nil,
        method: HTTPMethod = .get
    ) {
        self.destination = destination
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
        self.method = method
        self.logger = Logger.category("HTTPEndpoint \(method.rawValue) \(destination)")
    }
    
    func send(contentType: String = "application/json") async throws -> Response {
        // - MARK: Session
        let session = URLSession(configuration: .default)
        
        // - MARK: Request
        guard let url = URL(string: destination) else {
            throw HTTPEndpointError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                logger.error("\(loggerPrefix)\nError on encoding response: \(error)\n")
                throw HTTPEndpointError.encodingError
            }
        }
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // MARK: Headers
        if let headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        // MARK: Query Parameters
        if let queryParameters {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = components.url
        }
        
        let (data, urlResponse) = try await session.data(for: request)
        
        if let urlReponse = urlResponse as? HTTPURLResponse {
            if (400..<500).contains(urlReponse.statusCode) {
                logger.error("\(loggerPrefix)\n\(urlReponse.statusCode) Error")
                throw HTTPEndpointError.badRequest
            }
            
            if (500..<600).contains(urlReponse.statusCode) {
                logger.error("\(loggerPrefix)\n\(urlReponse.statusCode) Error")
                throw HTTPEndpointError.internalServerError
            }
        }
        
        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            logger.error("\(loggerPrefix)\nError on decoding response: \(error)\ndata: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw HTTPEndpointError.decodingError
        }
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum HTTPEndpointError: Error {
        case invalidURL
        case badRequest
        case internalServerError
        case encodingError
        case decodingError
        case others(Int)
    }
}
