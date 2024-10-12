//
//  Soundscape.swift
//  Soundscapes
//
//  Created by Josh Robertson on 10/11/24.
//


// SoundscapeData.swift

import SwiftUI

// Define the Soundscape model
struct Soundscape: Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var imageName: String
    var category: [String]
}

// Define the soundscapes with their categories
let soundscapes: [Soundscape] = [
    Soundscape(id: "IcelandGlacier", name: "Iceland Glacier", description: "The sounds of an ice cave deep within the Vatnajökull Glacier, with cave vocals.", imageName: "IcelandGlacier", category: ["Nature and Music"]),
    Soundscape(id: "Xochimilco", name: "Xochimilco Piano Sunrise", description: "The sunrise nature sounds of a protected wetland area in Mexico City with gentle piano.", imageName: "Xochimilco", category: ["Nature and Music"]),
    Soundscape(id: "RainStorm", name: "South Dakota Rain", description: "Journey to South Dakota, USA during a gentle rain storm with distant thunder.", imageName: "RainStorm", category: ["Nature Sounds"]),
    Soundscape(id: "TibetanBowls", name: "Tibetan Singing Bowls", description: "Sounds of ancient Tibetan singing bowls.", imageName: "TibetanBowls", category: ["Sound Healing"]),
    Soundscape(id: "OceanWaves", name: "Big Sur Ocean Waves", description: "The relaxing sounds of waves crashing in Big Sur, California.", imageName: "OceanWaves", category: ["Nature Sounds"]),
    Soundscape(id: "Antarctica", name: "Antarctica Waters with Ambient Music", description: "Featuring the underwater sound of glacial melt with a musical pad.", imageName: "Antarctica", category: ["Nature and Music"]),
    Soundscape(id: "Electronic", name: "Outer Space Frequencies", description: "An intriguing soundscape created from NASA's outer space frequencies.", imageName: "Electronic", category: ["Ambient Electronic"])
]
