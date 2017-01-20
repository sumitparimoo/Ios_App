//
//  ServerManager.swift
//  AudioEmotions
//
//  Created by Tejas Kharva on 11/30/16.
//  Copyright © 2016 Tejas Kharva. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class ServerManager: NSObject {
	
	static let sharedInstance = ServerManager()

	private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	func getCall() {
		
		let requestString = "http://localhost:8080/GlassFish_HelloWorld_war_exploded/helloworld"
		let request = NSMutableURLRequest(URL: NSURL(string: requestString)!)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.HTTPMethod = "GET"
		//request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(voicesArray, options: [])
		
		Alamofire.request(request)
			.responseString { response in
				switch response.result {
				case .Success(let responseObject):
					
					print(responseObject)
					
					break
				case .Failure(let error):
					print(error)
				}
		}
	}
	
	func contentString(content: NSData? = nil) -> String {
		if (content == nil) {
			return ""
		}
//		return "\(uriPrefix())\(content!.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed))"
		return "\(content!.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed))"
//		return "\(content!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0)))"
//		return "\(content!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))"
//		return "\(content!.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn))"
//		return "\(content!.base64EncodedStringWithOptions([.Encoding64CharacterLineLength, .EncodingEndLineWithCarriageReturn]))"
	}
	
	func contentString2(content: NSData? = nil) -> String {
		if (content == nil) {
			return ""
		}
		
		
		return "\(content!.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0)))"
	}
	
	func postAudioFile() {
		
		let data: NSData? = NSData(contentsOfFile: "/Users/tekhar/Personal/Dev/AudioEmotions/AudioEmotions/AudioEmotions/Classes/8-Bit-Noise-1.wav")
		
		
		var audioFile: AudioFile!
		
		do {
			let request = NSFetchRequest(entityName: "AudioFile")
			let audioFileArray = try managedObjectContext.executeFetchRequest(request) as! [AudioFile]
			audioFile = audioFileArray.last
		} catch {
			print(error)
		}
		
//		let audioFileString = contentString(audioFile.content)
//		let audioFileString2 = String(data: audioFile.content!, encoding: NSUTF8StringEncoding)
//		let audioFileString2 = contentString2(audioFile.content)
//		let audioFileString3 = contentString(data)
//		let audioFileString4 = data!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//		let audioFileString5 = data!.base64EncodedStringWithOptions(.Encoding76CharacterLineLength)
		let audioFileString6 = audioFile.content!.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
//		let audioFileString7 = data!.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
		
		let audioFileJSON = ["content" : audioFileString6]
//		let audioFileJSON = ["content" : "testing//iytf"]
//		let audioFileJSON2 = ["content" : audioFile.content as! AnyObject]
		
		let requestString = "http://localhost:8080/GlassFish_HelloWorld_war_exploded/helloworld/audio/"
		let request = NSMutableURLRequest(URL: NSURL(string: requestString)!)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//		request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
		request.HTTPMethod = "POST"
		//request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(voicesArray, options: [])
		request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(audioFileJSON, options: [])
		
		Alamofire.request(.POST, requestString, parameters: audioFileJSON, encoding: .JSON).responseString { response in
			switch response.result {
			case .Success(let responseObject):
				
				print(responseObject)
				
				break
			case .Failure(let error):
				print(error)
			}
		}
		
		/*
		Alamofire.request(request)
			.responseString { response in
				switch response.result {
				case .Success(let responseObject):
					
					print(responseObject)
					
					break
				case .Failure(let error):
					print(error)
				}
		}*/
	}
}
