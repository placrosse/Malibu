import Foundation
import When

public class Networking {

  enum SessionTaskKind {
    case Data, Upload, Download
  }

  let sessionConfiguration: SessionConfiguration

  lazy var session: NSURLSession = {
    return NSURLSession(configuration: self.sessionConfiguration.value)
  }()
  
  // MARK: - Initialization

  public init(baseURLString: URLStringConvertible, sessionConfiguration: SessionConfiguration = .Default) {
    self.sessionConfiguration = sessionConfiguration
  }
  
  // MARK: - Requests
  
  func execute(method: Method, request: Requestable) -> Promise<NetworkResult> {
    let promise = Promise<NetworkResult>()
    let URLRequest: NSMutableURLRequest
    
    do {
      URLRequest = try request.toURLRequest(method)
    } catch {
      promise.reject(error)
      return promise
    }

    session.dataTaskWithRequest(URLRequest, completionHandler: { data, response, error in
      guard let response = response as? NSHTTPURLResponse else {
        promise.reject(Error.NoResponseReceived)
        return
      }

      if let error = error {
        promise.reject(error)
        return
      }

      guard let data = data else {
        promise.reject(Error.NoDataInResponse)
        return
      }

      let result = NetworkResult(data: data, request: URLRequest, response: response)
      promise.resolve(result)
    }).resume()

    return promise
  }
}
