public protocol Schema {

  associatedtype EndpointType: Endpoint

  var endpointType: EndpointType { get }
  var baseUrl: URLStringConvertible { get }
  var headers: [String: String] { get }
  var sessionConfiguration: SessionConfiguration { get }
}

public protocol Endpoint: Requestable {

  var path: URLStringConvertible { get }
  var parameters: [String: Any] { get }
  var headers: [String: String] { get }
}
