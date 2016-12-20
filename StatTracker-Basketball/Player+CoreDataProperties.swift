//
//  Player+CoreDataProperties.swift
//  
//
//  Created by Ray Paragas on 20/12/16.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player");
    }

    @NSManaged public var playerFirstName: String?
    @NSManaged public var playerLastName: String?
    @NSManaged public var playerNumber: String?
    @NSManaged public var playerPosition: String?
    @NSManaged public var games: NSSet?
    @NSManaged public var team: Team?

}

// MARK: Generated accessors for games
extension Player {

    @objc(addGamesObject:)
    @NSManaged public func addToGames(_ value: GamePlayer)

    @objc(removeGamesObject:)
    @NSManaged public func removeFromGames(_ value: GamePlayer)

    @objc(addGames:)
    @NSManaged public func addToGames(_ values: NSSet)

    @objc(removeGames:)
    @NSManaged public func removeFromGames(_ values: NSSet)

}
