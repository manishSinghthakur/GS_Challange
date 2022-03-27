//
//  NetworkRequest.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

//  MARK: - Completion Handler

public typealias Completion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

//  MARK: - Protocol
protocol NetworkRouter {
    associatedtype EndPoint: RequestEndPoint
    func send(_ route: EndPoint, completion: @escaping Completion)
    func cancel()
}

//  MARK: - Base Class
class NetworkRequest<EndPoint: RequestEndPoint> : NetworkRouter {
    internal static var shared: NetworkRequest {
        return NetworkRequest()
    }
    private var task: URLSessionTask?
    func send(_ route: EndPoint, completion: @escaping Completion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            PrintInfo.shared.printRequest(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                PrintInfo.shared.printResponse(response: response)
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        guard  let urlString = route.baseURL.appendingPathComponent(route.path).absoluteString.removingPercentEncoding, let requestURL = URL(string: urlString)  else {
            return URLRequest(url: URL(fileURLWithPath:""))
        }
        var request = URLRequest(url: requestURL,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 50.0)
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.allHTTPHeaderFields = route.headers?.headers
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              _):
                
                self.addAdditionalHeaders(route.headers, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestMultiPartUpload(let bodyParameters,
                                     let bodyEncoding,
                                     let imageParameters,
                                     _):
                self.addAdditionalHeaders(route.headers, request: &request)
                try self.configureMultiPartParameters(bodyParameters: bodyParameters,
                                                      bodyEncoding: bodyEncoding,
                                                      imageParameters: imageParameters,
                                                      request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func configureMultiPartParameters(bodyParameters: Parameters?,
                                                  bodyEncoding: ParameterEncoding,
                                                  imageParameters: Parameters?,
                                                  request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: imageParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: NetworkHeaderInfo?, request: inout URLRequest) {
        guard let headers = additionalHeaders?.headers else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
