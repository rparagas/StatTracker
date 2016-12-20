//
//  Game+CoreDataProperties.swift
//  
//
//  Created by Ray Paragas on 20/12/16.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game");
    }

    @NSManaged public var gameDate: NSDate?
    @NSManaged public var gamePeriodLength: Int16
    @NSManaged public var gameTime: String?
    @NSManaged public var gameType: String?
    @NSManaged public var players: NSSet?
    @NSManaged public var teams: NSSet?

}

// MARK: Generated accessors for players
extension Game {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: GamePlayer)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: GamePlayer)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

// MARK: Generated accessors for teams
extension Game {

    @objc(addTeamsObject:)
    @NSManaged public func addToTeams(_ value: GameTeam)

    @objc(removeTeamsObject:)
    @NSManaged public func removeFromTeams(_ value: GameTeam)

    @objc(addTeams:)
    @NSManaged public func addToTeams(_ values: NSSet)

    @objc(removeTeams:)
    @NSManaged public func removeFromTeams(_ values: NSSet)

}
