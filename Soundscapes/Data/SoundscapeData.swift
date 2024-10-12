// SoundscapeData.swift

import Foundation

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
    Soundscape(id: "IcelandGlacier", name: "Iceland Glacier", description: "The sounds of an ice cave deep within the Vatnajökull Glacier, with cave vocals.", imageName: "IcelandGlacier", category: ["Nature Music"]),
    Soundscape(id: "Xochimilco", name: "Xochimilco Piano Sunrise", description: "The sunrise nature sounds of a protected wetland area in Mexico City with gentle piano.", imageName: "Xochimilco", category: ["Nature Music"]),
    Soundscape(id: "RainStorm", name: "South Dakota Rain", description: "Journey to South Dakota, USA during a gentle rain storm with distant thunder.", imageName: "RainStorm", category: ["Nature Sounds"]),
    Soundscape(id: "TibetanBowls", name: "Tibetan Singing Bowls", description: "Sounds of ancient Tibetan singing bowls.", imageName: "TibetanBowls", category: ["Sound Healing"]),
    Soundscape(id: "OceanWaves", name: "Big Sur Ocean Waves", description: "The relaxing sounds of waves crashing in Big Sur, California.", imageName: "OceanWaves", category: ["Nature Sounds"]),
    Soundscape(id: "Antarctica", name: "Antarctica Waters with Ambient Music", description: "Recorded and crafted by Madame Gandhi, featuring the underwater sound of glacial melt with a musical pad generated from the frequencies of nature.", imageName: "Antarctica", category: ["Nature Music"]),
    Soundscape(id: "Electronic", name: "Outer Space Frequencies", description: "An intriguing soundscape created from NASA's outer space frequencies.", imageName: "Electronic", category: ["Ambient Electronic"]),
    Soundscape(id: "432Acoustic", name: "432hz Acoustic Instruments", description: "A sound meditation feautring an ocean wave drum, crystal bowls, and shruti box all tuned to 432hz - a more natural tuning for aligning body and mind.", imageName: "432Acoustic", category: ["Sound Healing"]),
    Soundscape(id: "AutumnWind", name: "Autumn Wind with Piano and Violin", description: "The sounds of wind layered with evocative violin by Andreas Bernitt and piano by Josh Robertson.", imageName: "AutumnWind", category: ["Nature Music"])
]
