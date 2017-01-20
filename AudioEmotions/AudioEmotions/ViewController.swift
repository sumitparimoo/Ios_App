//
//  ViewController.swift
//  AudioEmotions
//
//  Created by Tejas Kharva on 11/29/16.
//  Copyright © 2016 Tejas Kharva. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import CoreData

class ViewController: UIViewController, AVAudioRecorderDelegate {
	
	var audioSession: AVAudioSession!
	var audioRecorder: AVAudioRecorder! = nil
	var audioPlayer: AVAudioPlayer! = nil
	
	var audioFile:AudioFile? = nil
	
	@IBOutlet var recordButton:UIButton!
	
	private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		audioSession = AVAudioSession.sharedInstance()
		
		do {
			try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
			try audioSession.setActive(true)
		} catch {
			print (error)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func getButtonPressed() {
		ServerManager.sharedInstance.getCall()
	}
	
	@IBAction func postButtonPressed() {
		ServerManager.sharedInstance.postAudioFile()
	}
	
	@IBAction func recordButtonPressed() {
		record()
	}
	
	@IBAction func playButtonPressed() {
		play()
	}
	
	func play() {
		do {
			let request = NSFetchRequest(entityName: "AudioFile")
			let audioFileArray = try managedObjectContext.executeFetchRequest(request) as! [AudioFile]
			
			
			audioPlayer = try AVAudioPlayer(data: audioFileArray.last!.content!)
			audioPlayer.prepareToPlay()
			audioPlayer.play()
			
		} catch {
			print (error)
		}
	}
	
	func record() {
		
		if audioRecorder != nil && audioRecorder.recording {
			audioRecorder.stop()
			
			recordButton .setImage(UIImage(named: "recordButton"), forState: .Normal)
			
		} else {
			
			recordButton .setImage(UIImage(named: "stopButton"), forState: .Normal)

			AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
				if granted {
					
					
					//get documnets directory
					//let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
					//let fullPath = documentsDirectory.stringByAppendingPathComponent("voiceRecording.caf")
					//let url = NSURL.fileURLWithPath(fullPath)
					let url = Utility.getDocumentsDirectoryURL().URLByAppendingPathComponent("auidioFile.wav")!
					
					//create AnyObject of settings
					/*let settings: [String : AnyObject] = [
						AVFormatIDKey:Int(kAudioFormatAppleIMA4), //Int required in Swift2
						AVSampleRateKey:44100.0,
						AVNumberOfChannelsKey:2,
						AVEncoderBitRateKey:12800,
						AVLinearPCMBitDepthKey:16,
						AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
					]*/
					
					let settings = [
						AVFormatIDKey: Int(kAudioFormatLinearPCM),
						AVSampleRateKey: 44100.0,
						AVNumberOfChannelsKey: 1 as NSNumber,
						AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
					]
					
					//record
					try! self.audioRecorder = AVAudioRecorder(URL: url, settings: settings)
					self.audioRecorder.delegate = self
					self.audioRecorder.record()
					
				} else {
					print("not granted")
				}
			})
		}
	}
	
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
		
		do {
			self.audioFile = AudioFile(needSave: true, context: self.managedObjectContext)
			self.audioFile?.fileName = "audioFile.wav"
			self.audioFile?.content = NSData(contentsOfURL: recorder.url)
			
			try self.managedObjectContext.save()
		} catch {
			print (error)
		}
	}
}

