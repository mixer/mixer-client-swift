//
//  RecordingsRoutes.swift
//  Pods
//
//  Created by Jack Cook on 6/12/16.
//
//

public class RecordingsRoutes {
    
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
    
    public func getRecordings(completion: ((recordings: [BeamRecording]?, error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/recordings") { (json, error) in
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
    
    public func markRecordingSeen(id: Int, completion: ((error: BeamRequestError?) -> Void)?) {
        BeamRequest.request("/recordings/\(id)/seen", requestType: "POST") { (json, error) in
            completion?(error: error)
        }
    }
}
