//
//  TetrisRoutes.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

public class TetrisRoutes {
    
    // MARK: Retrieving Tetris Data
    
    public func getTetrisDataByChannel(channelId: Int, completion: (data: TetrisData?, error: BeamRequestError?) -> Void) {
        BeamRequest.request("/tetris/\(channelId)", requestType: "GET") { (json, error) -> Void in
            guard let json = json else {
                completion(data: nil, error: error)
                return
            }
            
            let data = TetrisData(json: json)
            completion(data: data, error: error)
        }
    }
}
