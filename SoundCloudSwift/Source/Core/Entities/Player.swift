//import Foundation
//import AVFoundation
//import ReactiveCocoa
//
///// SoundCloud Player
//public class Player: NSObject, AVAudioPlayerDelegate {
//    
//    public enum State {
//        case Paused
//        case Playing
//        case Stopped
//        
//    }
//    
//    // MARK: - Attributes
//    
//    private var tracks: [Track]
//    private var player: AVAudioPlayer?
//    public var currentTrack: Track? {
//        get {
//            return tracks.first
//        }
//    }
//    public let state: MutableProperty<State> = MutableProperty(.Stopped)
//    
//    
//    // MARK: - Constructors
//    
//    init(tracks: [Track]) {
//        self.tracks = tracks
//    }
//    
//    
//    // MARK: - Helpers
//    
//    private func next() {
//        guard let track = tracks.first else { return }
//        player?.stop()
//        player = try? AVAudioPlayer(contentsOfURL: track.url)
//        player?.delegate = self
//        player?.prepareToPlay()
//        player?.play()
//    }
//    
//    
//    // MARK: - AVAudioPlayerDelegate
//    
//    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
//        state.value = .Stopped
//        if tracks.count > 0 { tracks.removeAtIndex(0) }
//        next()
//    }
//}