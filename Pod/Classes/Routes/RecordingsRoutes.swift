//
//  RecordingsRoutes.swift
//  Pods
//
//  Created by Jack Cook on 6/12/16.
//
//

/// Routes that can be used to interact with and retrieve recording data.
public class RecordingsRoutes {
    
    // MARK: Acting on Recordings
    
    /**
     Marks a recording as seen for the authenticated user.
     
     :param: id The id of the recording being marked.
     :param: completion An optional completion block that fires when the action has been completed.
     */
    public func markRecordingSeen(_ id: Int, completion: ((_ error: BeamRequestError?) -> Void)?) {
        guard let _ = BeamSession.sharedSession else {
            completion?(.notAuthenticated)
            return
        }
        
        BeamRequest.request("/recordings/\(id)/seen", requestType: "POST") { (json, error) in
            completion?(error: error)
        }
    }
    
    // MARK: Retrieving Recordings
    
    /**
     Retrieves a recording with the specified identifier.
     
     :param: id The identifier of the recording being retrieved.
     :param: completion An optional completion block with retrieved recording data.
     */
    public func getRecording(_ id: Int, completion: ((_ recording: BeamRecording?, _ error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/recordings/\(id)") { (json, error) in
            guard let json = json else {
                completion?(recording: nil, error: error)
                return
            }
            
            let recording = BeamRecording(json: json)
            completion?(recording: recording, error: error)
        }
    }
}
