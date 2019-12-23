//
//  DataProvider.swift
//  Peller_Task
//
//  Created by User on 12/20/19.
//  Copyright © 2019 GagikMelikyan. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit

final class DataProvider {
    
    private let session: URLSession
    private let host: String
    private let timestamp = String(NSDate().timeIntervalSince1970)
    private let publicKey = "f45e3ef45012f207bd5b27faaf94915a"
    private let privateKey = "4f048f751b4a2491cb25c34f0f4c86d8b9696791"
    
    init(host: String) {
        self.host = host
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    //MARK: Get Characters From Api
    func getCharacters(limit: Int, offset: Int, completion: @escaping (([Character]?) -> Void)) {
        
        let hash = (timestamp + privateKey + publicKey).md5
        
        let url = URL(string: host + "/v1/public/characters?" + "ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)" + "&limit=\(limit)&offset=\(offset)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
           
            let responseString = String(data: data, encoding: .utf8)
            if (responseString != nil) {
                let jsonData = responseString!.data(using: .utf8)!
                let decoder = JSONDecoder()
                let result = try? decoder.decode(CharctersData.self, from: jsonData)
                
                DispatchQueue.main.async {
                    completion(result?.data.results)
                }
            }
        }
        task.resume()
    }
}


//MARK: Extension. String to md5
extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
