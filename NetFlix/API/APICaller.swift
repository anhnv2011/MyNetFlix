//
//  APICaller.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import Foundation
struct Constans {
    static let ApiKey = "dc7bb41154658ee8cd23ecf49d7203c2"
    static let baseUrl = "https://api.themoviedb.org/"
    //60e988a2bc23f3c503e4f13773f593db83efadce
}

class APICaller {
    static let share = APICaller()
    
    func creatSessionWithLogin(username: String, password: String, requestToken: String, completion: @escaping (Result<TestAPi, Error>) -> Void){
        guard let url = URL(string: "\(Constans.baseUrl)3/authentication/token/validate_with_login?api_key=\(Constans.ApiKey)&username=\(username)&password=\(password)&request_token=\(requestToken)") else {
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
        guard let url = URL(string: "\(Constans.baseUrl)3/authentication/session/new?api_key=\(Constans.ApiKey)&request_token=\(requesToken)") else {
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
        guard let url = URL(string: "\(Constans.baseUrl)3/authentication/token/validate_with_login?api_key=\(Constans.ApiKey)&username=\(username)&password=\(password)&request_token=\(requestToken)") else {
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
        guard let url = URL(string: "\(Constans.baseUrl)3/authentication/token/new?api_key=\(Constans.ApiKey)") else {
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
    func getTrending (mediaType: String, time:String, completion: @escaping (Result<[Film], Error>) -> Void){
        guard let url = URL(string: "\(Constans.baseUrl)3/trending/\(mediaType)/\(time)?api_key=\(Constans.ApiKey)") else {return}
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
    
    func getPopular (mediaType: String, completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let url = URL(string: "\(Constans.baseUrl)3/\(mediaType)/popular?api_key=\(Constans.ApiKey)&language=en-US&page=1") else {return}
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
    
    func getTopRate (mediaType: String, completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let url = URL(string: "\(Constans.baseUrl)3/\(mediaType)/top_rated?api_key=\(Constans.ApiKey)&language=en-US&page=1") else {return}
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
        guard let url = URL(string: "\(Constans.baseUrl)3/\(mediaType)/upcoming?api_key=\(Constans.ApiKey)&language=en-US&page=1") else {return}
       
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
}
