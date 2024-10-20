import Foundation

// Define the Soundscape model
struct Soundscape: Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var imageURL: String // URL to S3 for image
    var audioURL: String // URL to S3 for audio
    var category: [String]
}

// Define the soundscapes with their categories
let soundscapes: [Soundscape] = [
    Soundscape(id: "IcelandGlacier",
               name: "Iceland Glacier",
               description: "The sounds of an ice cave deep within the Vatnajökull Glacier with cave vocals, recorded by Charles Van Kirk.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/IcelandGlacier.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/IcelandGlacier.mp3",
               category: ["Nature Music"]),
    Soundscape(id: "Xochimilco",
               name: "Xochimilco Piano Sunrise",
               description: "The sunrise nature sounds of a protected wetland area in Mexico City recorded by composer Leo Heiblum with piano by Josh Robertson.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Xochimilco.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Xochimilco.mp3",
               category: ["Nature Music"]),
    Soundscape(id: "RainStorm",
               name: "South Dakota Rain",
               description: "Journey to South Dakota, USA during a gentle rain storm with distant thunder, recorded by Charles Van Kirk.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/RainStorm.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/RainStorm.mp3",
               category: ["Nature Sounds"]),
    Soundscape(id: "TibetanBowls",
               name: "Tibetan Singing Bowls",
               description: "Sounds of ancient Tibetan singing bowls recorded by sound meditation expert Alexandre Tannous.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/TibetanBowls.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/TibetanBowls.mp3",
               category: ["Sound Healing"]),
    Soundscape(id: "OceanWaves",
               name: "Big Sur Ocean Waves",
               description: "The relaxing sounds of waves crashing in Big Sur, California.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/OceanWaves.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/OceanWaves.mp3",
               category: ["Nature Sounds"]),
    Soundscape(id: "Antarctica",
               name: "Antarctica Waters",
               description: "Recorded and crafted by Madame Gandhi, featuring the underwater sound of glacial melt with a musical pad generated from the frequencies of nature.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Antarctica.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Antarctica.mp3",
               category: ["Nature Music"]),
    Soundscape(id: "Electronic",
               name: "Outer Space Frequencies with Tristan Arp",
               description: "An intriguing soundscape created from NASA's outer space frequencies by Tristan Arp.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Electronic.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Electronic.mp3",
               category: ["Ambient Electronic"]),
    Soundscape(id: "432Acoustic",
               name: "432hz Acoustic Instruments",
               description: "A sound meditation featuring an ocean wave drum, crystal bowls, and shruti box all tuned to 432hz - a more natural tuning for aligning body and mind.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/432Acoustic.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/432Acoustic.mp3",
               category: ["Sound Healing"]),
    Soundscape(id: "AutumnWind",
               name: "Autumn Wind with Piano and Violin",
               description: "The sounds of wind layered with evocative violin by Andreas Bernitt and piano by Josh Robertson.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/AutumnWind.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/AutumnWind.mp3",
               category: ["Nature Music"])
]
