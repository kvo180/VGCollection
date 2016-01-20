//
//  IGDBConstants.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/16/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

extension IGDBClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: API
        static let APIKey = "JH4AMZykW4_6stmEZJTM_C-J4c2nmlikAhjFxE9zHN0"
        
        // MARK: URLs
        static let baseURLSecure: String = "https://www.igdb.com/api/v1/"
        static let baseImageURLSecure: String = "https://res.cloudinary.com/igdb/image/upload/t_"
    }
    
    // MARK: - Resources
    struct Resources {
        
        // MARK: Games
        static let Games = "games"
        static let GamesMeta = "games/meta"
        static let GamesID = "games/:id"
        static let GamesSearch = "games/search"
        
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
    
    // MARK: - Images
    // Note: IGDB contains either single or double DPR (Device Pixel Ratio) - get 2x images to better match with Retina display
    struct Images {
        static let CoverSmall = "cover_small_2x"
        static let ScreenShotMed = "screenshot_med_2x"
        static let CoverBig = "cover_big_2x"
        static let LogoMed = "logo_med_2x"
        static let ScreenShotBig = "screenshot_big_2x"
        static let ScreenShotHuge = "screenshot_huge_2x"
        static let Thumb = "thumb_2x"
        static let Micro = "micro_2x"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Games
        static let Games = "games"
        static let ID = "id"
        static let Name = "name"
        static let Slug = "slug"
        static let ReleaseDate = "release_date"
        static let ReleaseDates = "release_dates"
        static let AlternativeName = "alternative_name"
        static let Size = "size"
        static let Rating = "rating"
        static let PlatformName = "platform_name"
    }
}
