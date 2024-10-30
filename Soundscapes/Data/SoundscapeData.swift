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
    Soundscape(id: "Antarctica",
               name: "Antarctica Waters",
               description: "Recorded and crafted by Madame Gandhi, featuring the underwater sound of glacial melt with a musical pad generated from the frequencies of nature.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Antarctica.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Antarctica.mp3",
               category: ["Nature Music", "Featured"]),
    Soundscape(id: "MountainStreamMusic",
               name: "Rocky Mountain Stream Synth ",
               description: "A soundscape featuring meditative synths with a gently flowing stream in the Rocky Mountains.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/MountainStreamMusic.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/MountainStreamMusic.mp3",
               category: ["Nature Music",]),
    Soundscape(id: "RainStorm",
               name: "South Dakota Rain",
               description: "Journey to South Dakota, USA during a gentle rain storm with distant thunder, recorded by Charles Van Kirk.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/RainStorm.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/RainStorm.mp3",
               category: ["Nature Sounds"]),
    Soundscape(id: "TikalTemple",
               name: "Tikal Temple, Guatemala Sunrise",
               description: "Journey to a sunrise ambience near the Tikal Temple (or Temple of the Jaguar) in Guatemala, constructed by the Mayans.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/TikalTemple.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/TikalTemple.mp3",
               category: ["Nature Sounds"]),
    Soundscape(id: "Rwanda",
               name: "Rwanda Safari Lake",
               description: "Journey to Akagera National Park, to hear sounds of wildlife during a safari.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Rwanda.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Rwanda.mp3",
               category: ["Nature Sounds"]),
    Soundscape(id: "RainTent",
               name: "Rain on a Tent in The Badlands",
               description: "Listen to the gentle sounds of rain falling on a tent in The Badlands of South Dakota, recorded by Charles Van Kirk.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/RainTent.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/RainTent.mp3",
               category: ["Nature Sounds"]),
  
    Soundscape(id: "OceanWaves",
               name: "Big Sur Ocean Waves",
               description: "The relaxing sounds of waves crashing in Big Sur, California.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/OceanWaves.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/OceanWaves.mp3",
               category: ["Nature Sounds"]),
    Soundscape(id: "Bonneville",
               name: "Bonneville",
               description: "A lush electronic ambient soundscape inspired by a visit to the spacious Bonneville Salt Flats in Utah, musicians Charles Van Kirk, Christian Li and Mike Bono composed ",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Bonneville.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Bonneville.mp3",
               category: ["Ambient Electronic", "Featured"]),
    Soundscape(id: "Mushroom",
               name: "Mushroom Synthesis",
               description: "Field recordings from mushrooms synthesized into electronic ambient music.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Mushroom.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Mushroom.mp3",
               category: ["Ambient Electronic"]),
    Soundscape(id: "Electronic",
               name: "Outer Space Frequencies with Tristan Arp",
               description: "An intriguing soundscape created from NASA's outer space frequencies by Tristan Arp.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Electronic.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Electronic.mp3",
               category: ["Ambient Electronic"]),
    Soundscape(id: "TibetanBowls",
               name: "Tibetan Singing Bowls",
               description: "Sounds of ancient Tibetan singing bowls recorded by sound meditation expert Alexandre Tannous.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/TibetanBowls.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/TibetanBowls.mp3",
               category: ["Sound Healing"]),
    Soundscape(id: "432Acoustic",
               name: "432hz Acoustic Instruments",
               description: "A sound meditation featuring an ocean wave drum, crystal bowls, and shruti box all tuned to 432hz - a more natural tuning for aligning body and mind.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/432Acoustic.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/432Acoustic.mp3",
               category: ["Sound Healing"]),
    Soundscape(id: "SymphonicGong",
               name: "34 inch Symphonic Gong",
               description: "A sound meditation featuring the powerful full-frequency tones of a 34 inch symphonic gong.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/SymphonicGong.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/SymphonicGong.mp3",
               category: ["Sound Healing"]),
    Soundscape(id: "AutumnWind",
               name: "Autumn Wind with Piano and Violin",
               description: "The sounds of wind layered with evocative violin by Andreas Bernitt and piano by Josh Robertson.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/AutumnWind.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/AutumnWind.mp3",
               category: ["Nature Music", "Featured"]),
    Soundscape(id: "NYCSubway",
               name: "NYC Subway Ambience",
               description: "Take a trip on on the 7 Train of the famed NY Subway, and enjoy the ambient sounds of the city.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/NYCSubway.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/NYCSubway.mp3",
               category: ["City Sounds"]),
    Soundscape(id: "BarcelonaStreet",
               name: "Barcelona Street Ambience",
               description: "The ambient city sounds of an afternoon in Barcelona, Spain.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/BarcelonaStreet.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/BarcelonaStreet.mp3",
               category: ["City Sounds"]),
    Soundscape(id: "Bazaar",
               name: "New Delhi, India Bazaar",
               description: "The ambient city sounds of a bustling Bazaar in New Delhi, India.",
               imageURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Bazaar.jpg",
               audioURL: "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/Soundscape+Audio/Bazaar.mp3",
               category: ["City Sounds"]),
    
    
]
