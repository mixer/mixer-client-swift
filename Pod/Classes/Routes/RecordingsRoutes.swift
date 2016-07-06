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
    public func markRecordingSeen(id: Int, completion: ((error: BeamRequestError?) -> Void)?) {
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
    public func getRecording(id: Int, completion: ((recording: BeamRecording?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/recordings/\(id)") { (json, error) in
            guard let json = json else {
                completion?(recording: nil, error: error)
                return
            }
            
            let recording = BeamRecording(json: json)
            completion?(recording: recording, error: error)
        }
    }
    
    /**
     Retrieves all recordings on a specified channel.
     
     :param: channelId The id of the channel recordings are being retrieved from.
     :param: completion An optional completion block with the retrieved recordings' data.
     */
    public func getRecordingsByChannel(channelId: Int, completion: ((recordings: [BeamRecording]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/recordings?where=channelId.eq.\(channelId)") { (json, error) in
            guard let json = json, let recordings = json.array else {
                completion?(recordings: nil, error: error)
                return
            }
            
            var retrievedRecordings = [BeamRecording]()
            
            for recording in recordings {
                let retrievedRecording = BeamRecording(json: recording)
                retrievedRecordings.append(retrievedRecording)
            }
            
            completion?(recordings: retrievedRecordings, error: error)
        }
    }
}
