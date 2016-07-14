//
//  TetrisRoutes.swift
//  Pods
//
//  Created by Jack Cook on 2/27/16.
//
//

/// Routes that can be used to interact with and receive tetris data.
public class TetrisRoutes {
    
    // MARK: Retrieving Tetris Data
    
    /**
     Retrieves details used to connect to a channel's tetris socket.
    
     :param: channelId The id of the channel being connected to.
     :param: completion An optional completion block with retrieved tetris details.
     */
    public func getTetrisDataByChannel(channelId: Int, completion: ((data: TetrisData?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/tetris/\(channelId)") { (json, error) in
            guard let json = json else {
                completion?(data: nil, error: error)
                return
            }
            
            let data = TetrisData(json: json)
            completion?(data: data, error: error)
        }
    }
}
