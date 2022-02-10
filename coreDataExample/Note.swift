//
//  Note.swift
//  coreDataExample
//
//  Created by Maximiliano Riquelme Vera on 10/02/2022.
//

import Foundation
import CoreData

@objc(Note)
class Note: NSManagedObject
{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date?
}
