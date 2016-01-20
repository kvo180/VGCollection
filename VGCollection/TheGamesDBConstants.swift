//
//  TheGamesDBConstants.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/18/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

extension TheGamesDBClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: URLs
        static let baseURLSecure: String = "http://thegamesdb.net/api/"
    }
    
    // MARK: - Resources
    struct Resources {
        
        // MARK: GetGamesList
        static let GetGamesList = "GetGamesList.php"
        static let Name = "name"
        static let Platform = "platform"
        static let Genre = "genre"
        
        // MARK: Companies
        static let Companies = "companies"
        static let CompaniesMeta = "companies/meta"
        static let CompaniesID = "companies/:id"
        static let CompaniesGames = "companies/:id/games"
        
        // MARK: People
        static let People = "people"
        static let PeopleMeta = "people/meta"
        static let PeopleID = "people/:id"
        static let PeopleGames = "people/:id/games"
        
        // MARK: Franchises
        static let Franchises = "franchises"
        static let FranchisesMeta = "franchises/meta"
        static let FranchisesID = "franchises/:id"
        static let FranchisesGames = "franchises/:id/games"
        
        // MARK: Platforms
        static let Platforms = "platforms"
        static let PlatformsMeta = "platforms/meta"
        static let PlatformsID = "platforms/:id"
        static let PlatformsGames = "platforms/:id/games"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: GetGamesList
        static let ID = "id"
        static let GameTitle = "GameTitle"
        static let ReleaseDate = "ReleaseDate"
        static let Platform = "Platform"
        
    }
}
