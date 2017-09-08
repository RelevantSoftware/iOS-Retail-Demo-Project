//
//  RequestOperation.swift
//

import Alamofire

extension Notification.Name {
    
    static let http401ErrorNotification = Notification.Name("HTTP401ErrorNotification")
}

class RequestOperation: ConcurrentOperation {
    let path: String
    let headerFields: [String: String]?
    let parameters: Parameters?
    let fileData: FileData?
    let networkMethod: NetworkMethod
    let completion: ((Any?, Error?) -> Void)?
    private(set) var result: Any?
    private(set) var json: Any?
    private(set) var statusCode: Int?
    private(set) var error: Error?
    private(set) var dataTask: URLSessionDataTask?
    typealias EncodingCompletion = ((SessionManager.MultipartFormDataEncodingResult) -> Void)?
    
    required init(networkMethod: NetworkMethod, path: String, headerFields: [String: String]? = nil, parameters: Parameters? = nil, fileData: FileData? = nil, completion: ((Any?, Error?) -> Void)? = nil) {
        self.networkMethod = networkMethod
        self.path = path
        self.headerFields = headerFields
        self.parameters = parameters
        self.completion = completion
        self.fileData = fileData
    }
    
    override func start() {
        if isCancelled {
            return
        }
        setValue(true, forKey: executingKey)
        
        if self.networkMethod == NetworkMethod.local {
            self.sendLocalRequest()
        } else {
            self.sendAlamofireRequest(request: self.createRequestWithURL(url: self.createURLWithPath(path: self.path) as URL), encodingCompletion: self.createEncodingCompletion())
        }
    }
    
    private func sendLocalRequest() {
        do {
            if let file = Bundle.main.url(forResource: self.path,
                withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    self.result = object
                    self.finishExecuting()
                } else if let array = json as? [Any] {
                    // json is an array
                    self.result = array
                    self.finishExecuting()
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createURLWithPath(path: String) -> URL {
        let urlString = RequestOperation.baseURL.absoluteString + path
        var url = URL(string: urlString)!
        print("path: \(path)")
        if path[path.startIndex] == "/" {
            
            if let host = RequestOperation.baseURL.host {
                let originalPath = NSURL(fileURLWithPath: RequestOperation.baseURL.scheme! + "://" + host)
                print("originalPath: \(originalPath)")
                url = originalPath.appendingPathComponent(path)!
            }
        }
        print("request: \(url)")
        return url
    }
    
    private func createRequestWithURL(url: URL) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: url)
        
        if let parameters = self.parameters {
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            } catch _ {
                debugPrint("ERROR!! NSJSONSerialization")
            }
        }
        return request
    }
    
    private func createEncodingCompletion() -> EncodingCompletion {
        return { [weak self] encodingResult in
            guard let strongSelf = self else {
                return
            }
            switch encodingResult {
            case .success(let request, _, _):
                if !strongSelf.isCancelled {
                    request.responseJSON(completionHandler: { (response) -> Void in
                        if let data = response.data {
                            let json = try? JSONSerialization.jsonObject(with: data,
                                options: .allowFragments)
                            strongSelf.json = json
                        }
                        strongSelf.error = response.result.error
                        strongSelf.result = response.result.value as AnyObject?
                        strongSelf.statusCode = response.response?.statusCode
                        strongSelf.finishExecuting()
                    })
                }
            case .failure:
                if !strongSelf.isCancelled {
                    strongSelf.finishExecuting()
                }
            }
        }
    }
    
    private func sendAlamofireRequest(request: NSMutableURLRequest,
        encodingCompletion: EncodingCompletion) {
        
        guard let alamofireMethod: HTTPMethod = Alamofire.HTTPMethod(rawValue: self.networkMethod.rawValue) else {
            debugPrint("ERROR: Problem with init HTTPMethod with \(self.networkMethod.rawValue) rawValue")
            return
        }
        
        if let fileData = self.fileData {
            Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) -> Void in
                multipartFormData.append(fileData.data, withName: fileData.name,
                    fileName: fileData.fileName, mimeType: fileData.mimeType)
            }, to: request.url!, method: alamofireMethod, headers: self.headerFields,
            encodingCompletion: encodingCompletion)
        } else {
            Alamofire.request(request.url!, method: alamofireMethod, parameters: self.parameters,
                encoding: JSONEncoding.default, headers: self.headerFields)
                .validate(statusCode: 200..<400)
                .responseJSON { response in
                    if response.response?.statusCode == 401 {
                        NotificationCenter.default.post(name: .http401ErrorNotification, object: nil)
                    }
                    
                    if !self.isCancelled {
                        if let data = response.data {
                            let json = try? JSONSerialization.jsonObject(with: data,
                                options: .allowFragments)
                            self.json = json
                        }
                        self.result = response.result.value
                        self.error = response.result.error
                        self.statusCode = response.response?.statusCode
                        self.finishExecuting()
                    }
                    debugPrint(self.json ?? [:])
            }
        }
    }
    
    private func finishExecuting() {
        self.setValue(false, forKey: self.executingKey)
        self.setValue(true, forKey: self.finishedKey)
        self.completion?(self.result, self.error)
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func cancel() {
        super.cancel()
        dataTask?.cancel()
    }
    
    func stringType() -> String {
        return ""
    }
    
    override var description: String {
        let requestURL = RequestOperation.baseURL.appendingPathComponent(self.path)
        return self.stringType() + " \(requestURL)"
    }
    
    func dataTaskWithCompletion(completion: ((AnyObject?, NSError?) -> Void)? = nil) -> URLSessionDataTask? {
        assertionFailure("You must override \(#function) in a subclass")
        return nil
    }
    
    //Put Your URL here
    static let baseURL = Settings.app.baseURL
}
