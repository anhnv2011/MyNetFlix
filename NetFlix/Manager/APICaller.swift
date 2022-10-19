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



struct Constanst {
    static let ApiKey = "dc7bb41154658ee8cd23ecf49d7203c2"
    static let baseUrl = "https://api.themoviedb.org/"
    static let YoutubeAPI_KEY = "AIzaSyDyHzGYOyLL5yRPjwfQafppIavwUUFrZKo"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    static let ImageBaseUrl = "https://image.tmdb.org/t/p/w500/"
    
}


class APICaller {
    static let share = APICaller()
    
    
    func creatSessionWithLogin(username: String, password: String, requestToken: String, completion: @escaping (Result<LoginResponse, Error>) -> Void){
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
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                print(result)
                completion(.success(result))
                
            } catch {
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
    
    
    
}
//MARK:- WatchList
extension APICaller {
    func getWatchList(mediaType: String,sessonid: String, profileID: String, completion: @escaping (Result<[Film], Error>) -> Void) {
  
        
        guard let url = URL(string:       "\(Constanst.baseUrl)3/account/\(profileID)/watchlist/\(mediaType)?api_key=\(Constanst.ApiKey)&language=en-US&session_id=\(sessonid)&sort_by=created_at.asc&page=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil else {return}
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                             print(json)
                let result = try JSONDecoder().decode(Trending.self, from: data)
                
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func postWatchList(mediaType: String, mediaId: Int,type:Bool, completion: @escaping (Result<StatusResponse, Error>) -> Void){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        let url = "\(Constanst.baseUrl)3/account/\(profileid)/watchlist?api_key=\(Constanst.ApiKey)&session_id=\(sessionid)"
   
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // Serialize HTTP Body data as JSON
        let body = [
            "media_type": mediaType,
            "media_id": mediaId,
            "watchlist": type
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
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print(json)
                let result = try JSONDecoder().decode(StatusResponse.self, from: data)
                print(result)
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
}

//MARK:- Favorite
extension APICaller {
    func postFavorite(mediaType: String, mediaId: Int,type: Bool, completion: @escaping (Result<StatusResponse, Error>) -> Void){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        let url = "\(Constanst.baseUrl)3/account/\(profileid)/favorite?api_key=\(Constanst.ApiKey)&session_id=\(sessionid)"
   
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // Serialize HTTP Body data as JSON
        let body = [
            "media_type": mediaType,
            "media_id": mediaId,
            "favorite": type
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
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print(json)
                let result = try JSONDecoder().decode(StatusResponse.self, from: data)
                print(result)
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
    
    func getMovieFavorite(sessonid: String, profileID: String, completion: @escaping (Result<[Film], Error>) -> Void) {
       
        guard let url = URL(string: "\(Constanst.baseUrl)3/account/\(profileID)/favorite/movies?api_key=\(Constanst.ApiKey)&session_id=\(sessonid)&language=en-US&sort_by=created_at.asc&page=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil else {return}
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print(json)
                let result = try JSONDecoder().decode(Trending.self, from: data)
                
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTVFavorite(sessonid: String, profileID: String, completion: @escaping (Result<[Film], Error>) -> Void) {
       
        guard let url = URL(string: "\(Constanst.baseUrl)3/account/\(profileID)/favorite/tv?api_key=\(Constanst.ApiKey)&session_id=\(sessonid)&language=en-US&sort_by=created_at.asc&page=1") else {return}
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
    
}

//MARK:- Get Genres
extension APICaller {
    
    
}



//MARK:- List
extension APICaller {
    func getLists(profileID: String, sessionId: String, completion: @escaping (Result<[Lists], Error>) -> Void){
        guard let url =  URL(string: "\(Constanst.baseUrl)3/account/\(profileID)/lists?api_key=\(Constanst.ApiKey)&language=en-US&session_id=\(sessionId)&page=1") else {
            return
        }

        AF.request(url, method: .get, parameters: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                let lists = ListResponse(JSON(data))
                completion(.success(lists.results!))
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    func addFilmToList(listId:String, mediaId: Int,sessionId:String, completion: @escaping (Result<StatusResponse, Error>) -> Void){
        let url =  "\(Constanst.baseUrl)3/list/\(listId)/add_item?api_key=\(Constanst.ApiKey)&session_id=\(sessionId)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // Serialize HTTP Body data as JSON
        let body = [
            "media_id": mediaId
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
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(StatusResponse.self, from: data)
                print(result)
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    func postList(sessionId: String, name: String, description: String, completion: @escaping (Result<StatusResponse, Error>) -> Void){
        let url = "\(Constanst.baseUrl)3/list?api_key=\(Constanst.ApiKey)&session_id=\(sessionId)"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // Serialize HTTP Body data as JSON
        let body = [
            "name": name,
            "description": description,
            "language": "en"
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
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(StatusResponse.self, from: data)
                print(result)
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    func deleteList(sessionID: String, listID: Int, completion: @escaping (Result<StatusResponse, Error>) -> Void){
        let url = "\(Constanst.baseUrl)3/list/\(listID)?api_key=\(Constanst.ApiKey)&session_id=\(sessionID)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "DELETE"
        // Create the HTTP request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(StatusResponse.self, from: data)
                print(result)
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
}

//MARK:- Youtube
extension APICaller {
    
    func getFilmLink(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constanst.YoutubeBaseURL)q=\(query)&key=\(Constanst.YoutubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
              
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                

            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
}

//MARK:- Rate
extension APICaller {
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
    
    func getRate(mediaType: String,profileID: String, sessionID: String, completion: @escaping (Result<[Film], Error>) -> Void ){
        guard let url = URL(string: "\(Constanst.baseUrl)3/account/\(profileID)/rated/\(mediaType)?api_key=\(Constanst.ApiKey)&language=en-US&session_id=\(sessionID)&sort_by=created_at.asc&page=1") else {return}
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
    
    func postRate(mediaType: String, filmId: Int, sessionId: String, value: Double, completion: @escaping (Result<StatusResponse, Error>) -> Void){
        let url = "\(Constanst.baseUrl)3/\(mediaType)/\(filmId)/rating?api_key=\(Constanst.ApiKey)&session_id=\(sessionId)"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // Serialize HTTP Body data as JSON
        let body = [
            "value": value
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
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(StatusResponse.self, from: data)
//                print(result)
                completion(.success(result))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
}

//MARK:- Similar
extension APICaller {
    func getSimilarFilm(mediaType: String, filmID: Int, completion: @escaping (Result<[Film], Error>) -> Void){
        guard let url = URL(string: "\(Constanst.baseUrl)3/\(mediaType)/\(filmID)/similar?api_key=\(Constanst.ApiKey)") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil else {return}
            do {
                let result = try JSONDecoder().decode(SimilarResponse.self, from: data)
                
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension APICaller {
    
    //    func getFriends() -> Observable<[Friend]> {
    //        return Observable.create { observer -> Disposable in
    //            AF.request("http://friendservice.herokuapp.com/listFriends")
    //                .validate()
    //                .responseJSON { response in
    //                    switch response.result {
    //                    case .success:
    //                        guard let data = response.data else {
    //
    //                            observer.onError(response.error ?? GetFriendsFailureReason.notFound)
    //                            return
    //                        }
    //                        do {
    //                            let friends = try JSONDecoder().decode([Friend].self, from: data)
    //                            observer.onNext(friends)
    //                        } catch {
    //                            observer.onError(error)
    //                        }
    //                    case .failure(let error):
    //                        if let statusCode = response.response?.statusCode,
    //                            let reason = GetFriendsFailureReason(rawValue: statusCode)
    //                        {
    //                            observer.onError(reason)
    //                        }
    //                        observer.onError(error)
    //                    }
    //            }
    //
    //            return Disposables.create()
    //        }
    //    }
}
//struct Friend: Codable {
//    
//    let firstname: String
//    let id: Int
//    let lastname: String
//    let phonenumber: String
//    
//}
//enum GetFriendsFailureReason: Int, Error {
//    case unAuthorized = 401
//    case notFound = 404
//}
