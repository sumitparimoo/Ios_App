//
//  Utility.swift
//  AudioEmotions
//
//  Created by Tejas Kharva on 12/4/16.
//  Copyright © 2016 Tejas Kharva. All rights reserved.
//

import Foundation

class Utility: NSObject {
	
	static func getDocumentsDirectoryURL(directory: String = "") -> NSURL {
		var documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
		
		let mainDirectory = "local_device"
		
		documentsURL = documentsURL.URLByAppendingPathComponent(mainDirectory)!
		documentsURL = documentsURL.URLByAppendingPathComponent(directory)!
		
		//create directory if it doesn't exist
		if !NSFileManager.defaultManager().fileExistsAtPath(documentsURL.relativePath!) {
			do {
				try NSFileManager.defaultManager().createDirectoryAtPath(documentsURL.relativePath!, withIntermediateDirectories: true, attributes: nil)
			} catch let error as NSError {
				print(error.localizedDescription);
			}
		}
		
		return documentsURL
	}
}
