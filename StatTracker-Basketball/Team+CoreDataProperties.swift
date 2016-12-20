//
//  Team+CoreDataProperties.swift
//  
//
//  Created by Ray Paragas on 20/12/16.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team");
    }

    @NSManaged public var teamDivision: String?
    @NSManaged public var teamName: String?
    @NSManaged public var teamType: String?
    @NSManaged public var games: NSSet?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for games
extension Team {

    @objc(addGamesObject:)
    @NSManaged public func addToGames(_ value: GameTeam)

    @objc(removeGamesObject:)
    @NSManaged public func removeFromGames(_ value: GameTeam)

    @objc(addGames:)
    @NSManaged public func addToGames(_ values: NSSet)

    @objc(removeGames:)
    @NSManaged public func removeFromGames(_ values: NSSet)

}

// MARK: Generated accessors for players
extension Team {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}
