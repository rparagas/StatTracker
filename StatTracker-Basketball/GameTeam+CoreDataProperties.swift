//
//  GameTeam+CoreDataProperties.swift
//  
//
//  Created by Ray Paragas on 20/12/16.
//
//

import Foundation
import CoreData


extension GameTeam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameTeam> {
        return NSFetchRequest<GameTeam>(entityName: "GameTeam");
    }

    @NSManaged public var homeTeam: Bool
    @NSManaged public var game: Game?
    @NSManaged public var team: Team?

}
