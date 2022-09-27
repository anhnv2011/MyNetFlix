//
//  APICaller.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}

struct Constanst {
    static let ApiKey = "dc7bb41154658ee8cd23ecf49d7203c2"
    static let baseUrl = "https://api.themoviedb.org/"
    static let YoutubeAPI_KEY = "AIzaSyDyHzGYOyLL5yRPjwfQafppIavwUUFrZKo"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    
    static let ImageBaseUrl = "https://image.tmdb.org/t/p/w500/"
    struct Parameters {
           static let userId = "userId"
       }
       
       //The header fields
       enum HttpHeaderField: String {
           case authentication = "Authorization"
           case contentType = "Content-Type"
           case acceptType = "Accept"
           case acceptEncoding = "Accept-Encoding"
       }
       
       //The content type (JSON)
       enum ContentType: String {
           case json = "application/json"
       }
}
struct Friend: Codable {

    let firstname: String
    let id: Int
    let lastname: String
    let phonenumber: String

}
enum GetFriendsFailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}

class APICaller {
    static let share = APICaller()
    
    func getFriends() -> Observable<[Friend]> {
        return Observable.create { observer -> Disposable in
            AF.request("http://friendservice.herokuapp.com/listFriends")
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                        
                            observer.onError(response.error ?? GetFriendsFailureReason.notFound)
                            return
                        }
                        do {
                            let friends = try JSONDecoder().decode([Friend].self, from: data)
                            observer.onNext(friends)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = GetFriendsFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }

            return Disposables.create()
        }
    }
    
    func creatSessionWithLogin(username: String, password: String, requestToken: String, completion: @escaping (Result<TestAPi, Error>) -> Void){
        guard let url = URL(string: "\(Constanst.baseUrl)3/authentication/token/validate_with_login?api_key=\(Constanst.ApiKey)&username=\(username)&password=\(password)&request_token=\(requestToken)") else {
            print("invalid url")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            do {
                
                //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let result = try JSONDecoder().decode(TestAPi.self, from: data)
                print(result)
                completion(.success(result))

            } catch {
                print("nhap sai user")
                completion(.failure(error))
            }
        }
        task.resume()
        
        
        
        
    }
    func getSessionId(requesToken:String, completion: @escaping (Result<String, Error>)->Void){
        guard let url = URL(string: "\(Constanst.baseUrl)3/authentication/session/new?api_key=\(Constanst.ApiKey)&request_token=\(requesToken)") else {
            print("invalid url")
            return
        }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data, error == nil else {
                print("invalid")
                return
            }
            do {
                
//                let result = try JSONDecoder().decode(SessionId.self, from: data)
//                print(result.session_id)
               //completion(.success(result.session_id))
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(result)
                let a = try JSONDecoder().decode(SessionId.self, from: data)
                print(a.session_id)
                completion(.success(a.session_id))
                //                print(result.session_id)
            } catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    func login(username: String, password: String, requestToken: String, completion: @escaping (Result<Authentication, Error>) -> Void){
        guard let url = URL(string: "\(Constanst.baseUrl)3/authentication/token/validate_with_login?api_key=\(Constanst.ApiKey)&username=\(username)&password=\(password)&request_token=\(requestToken)") else {
            print("invalid url")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            do {
                
                //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let result = try JSONDecoder().decode(Authentication.self, from: data)
                completion(.success(result))

            } catch {
                print("nhap sai user")
                completion(.failure(error))
            }
        }
        task.resume()
        
        
        
        
    }
    
    func getRequestToken(compeltion: @escaping (Result<RequestToken, Error>) -> Void){
        guard let url = URL(string: "\(Constanst.baseUrl)3/authentication/token/new?api_key=\(Constanst.ApiKey)") else {
            return
        }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data,
                  error == nil else {
               
                return
                
            }
            do {
                //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let result = try JSONDecoder().decode(RequestToken.self, from: data)
                print(result)
                compeltion(.success(result))
                //print(result.request_token)
            
            } catch {
                compeltion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    func getTrending (mediaType: MediaType, time: TimeWindow, completion: @escaping (Result<[Film], Error>) -> Void){
        guard let url = URL(string: "\(Constanst.baseUrl)3/trending/\(mediaType.rawValue)/\(time.rawValue)?api_key=\(Constanst.ApiKey)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data,
                  error == nil else {return}
            do {
                //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let result = try JSONDecoder().decode(Trending.self, from: data)
                completion(.success(result.results))
                //print(result)
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getPopular (mediaType: MediaType, completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let url = URL(string: "\(Constanst.baseUrl)3/\(mediaType.rawValue)/popular?api_key=\(Constanst.ApiKey)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil else {return}
            do {
                let result = try JSONDecoder().decode(Trending.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    func getTopRate (mediaType: MediaType, completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let url = URL(string: "\(Constanst.baseUrl)3/\(mediaType.rawValue)/top_rated?api_key=\(Constanst.ApiKey)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil else {return}
            do {
                let result = try JSONDecoder().decode(Trending.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    func getUpcomming (mediaType: String, completion: @escaping (Result<UpComming, Error>) -> Void) {
        guard let url = URL(string: "\(Constanst.baseUrl)3/\(mediaType)/upcoming?api_key=\(Constanst.ApiKey)&language=en-US&page=1") else {return}
       
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil else {return}
            do {
                //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let result = try JSONDecoder().decode(UpComming.self, from: data)
                completion(.success(result))
                //print(result)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let url = URL(string: "\(Constanst.baseUrl)3/discover/movie?api_key=\(Constanst.ApiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Trending.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    
    func search(with query: String, completion: @escaping (Result<[Film], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constanst.baseUrl)3/search/movie?api_key=\(Constanst.ApiKey)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Trending.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
  
    func getCurrentProfile(completion: @escaping (Result<Profile, Error>) -> Void){
        let url = "\(Constanst.baseUrl)3/account"
        let sessionid = DataManager.shared.getSaveSessionId()
        print(sessionid)
        let parameters: Parameters = [
            "api_key" : "\(Constanst.ApiKey)" ,
            "session_id" : sessionid
        ]
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                let profile = Profile(JSON(data))
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
                
            }
        }

    }

    func postFavorite(){
        let sessionid = DataManager.shared.getSaveSessionId()

        let url = "\(Constanst.baseUrl)3/account/12405634/favorite?api_key=\(Constanst.ApiKey)&session_id=\(sessionid)"
//        let url = "https://api.themoviedb.org/3/account/12405634/favorite?api_key=dc7bb41154658ee8cd23ecf49d7203c2&session_id=e93545ffb948fff28596f7fa8958749ec1a7e05f"
//        let parameters: Parameters = [
//            "api_key" : "\(Constanst.ApiKey)" ,
//            "session_id" : sessionid
//        ]
//        let headers = ["Content-Type" : "application/json;charset=utf-8"]
//        let body = [
//            "media_type": "movie",
//            "media_id": "550",
//            "favorite": "true"
//          ]
       
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
       
        // Serialize HTTP Body data as JSON
        let body = [
            "media_type": "movie",
            "media_id": 550,
            "favorite": true
        ] as [String : Any]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )

        // Change the URLRequest to a POST request
        request.httpMethod = "POST"
        request.httpBody = bodyData

        // Create the HTTP request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
               print(error)
            } else if let data = data {
                do {
                    let results = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(results)
                } catch {
                    print("")
                }
            } else {
                // Handle unexpected error
            }
        }
        task.resume()

    }
}
