//
//  AudioRecorder.swift


import Foundation
import AVFoundation


class AudioRecorder : NSObject , AVAudioRecorderDelegate{
    var recordingSection : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    var isAudioRecordingGranted : Bool!
    
    static let shared = AudioRecorder()
    
    private override init(){
        super.init()
        
        checkForRecordPermision()
        
    }
    
    // take sure that the app has the permission to use voice if not know ask for permision
    func checkForRecordPermision(){
        switch AVAudioSession.sharedInstance().recordPermission{
        case .granted:
            isAudioRecordingGranted = true
            break
        case .denied:
            isAudioRecordingGranted = false
            break
        case.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { isAllowd in
                self.isAudioRecordingGranted = isAllowd
            }
        default:
            break
        }
    }
    
    func setUpRecorder(){
        if isAudioRecordingGranted {
            recordingSection = AVAudioSession.sharedInstance()
            do {
                try recordingSection.setCategory(.playAndRecord , mode : .default)
                try recordingSection.setActive(true)
            }catch{
                print("Error setting up recording Section" , error.localizedDescription)
            }
        }
    }
    
    func startRecording(fileName : String){
        
        // file to save the audio
        let audioFileName = getDocumentURL().appendingPathComponent(fileName+".m4a" , isDirectory: false)
        
        // a way to make the audio has better quality and less size
        let settings = [
            
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 1200,
            AVNumberOfChannelsKey : 1,
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
            
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        }catch{
            print("error recording" , error.localizedDescription)
            finishRecording()
        }
        
    }
    func finishRecording(){
        if audioRecorder != nil{
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
}
