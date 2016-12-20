//
//  GamePlayer+CoreDataProperties.swift
//  
//
//  Created by Ray Paragas on 20/12/16.
//
//

import Foundation
import CoreData


extension GamePlayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GamePlayer> {
        return NSFetchRequest<GamePlayer>(entityName: "GamePlayer");
    }

    @NSManaged public var playerAssist: Int16
    @NSManaged public var playerBlock: Int16
    @NSManaged public var playerDefRebound: Int16
    @NSManaged public var playerFoul: Int16
    @NSManaged public var playerOffRebound: Int16
    @NSManaged public var playerOnePointMake: Int16
    @NSManaged public var playerOnePointMiss: Int16
    @NSManaged public var playerSteal: Int16
    @NSManaged public var playerThreePointMake: Int16
    @NSManaged public var playerThreePointMiss: Int16
    @NSManaged public var playerTurnover: Int16
    @NSManaged public var playerTwoPointMake: Int16
    @NSManaged public var playerTwoPointMiss: Int16
    @NSManaged public var game: Game?
    @NSManaged public var player: Player?

}
