//
//  AudioFile.swift
//  AudioEmotions
//
//  Created by Tejas Kharva on 12/4/16.
//  Copyright © 2016 Tejas Kharva. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AudioFile: NSManagedObject {
	
	@NSManaged var fileName:String?
	@NSManaged var content:NSData?
	
	convenience init(needSave: Bool, context: NSManagedObjectContext?) {
		
		let entity = NSEntityDescription.entityForName("AudioFile", inManagedObjectContext: context!)
		
		
		if(!needSave) {
			self.init(entity: entity!, insertIntoManagedObjectContext: nil)
		} else {
			self.init(entity: entity!, insertIntoManagedObjectContext: context)
		}
	}
}
