//import Foundation

let quotes = [
    "The wound is the place where the Light enters you. - Rumi",
    "Life is like riding a bicycle. To keep your balance, you must keep moving. - Albert Einstein",
    "What lies behind us and what lies before us are tiny matters compared to what lies within us. - Ralph Waldo Emerson",
    "Be the change that you wish to see in the world. - Mahatma Gandhi",
    "The journey of a thousand miles begins with one step. - Lao Tzu",
    "Go confidently in the direction of your dreams. Live the life you have imagined. - Henry David Thoreau",
    "Everything you can imagine is real. - Pablo Picasso",
    "In the midst of movement and chaos, keep stillness inside of you. - Deepak Chopra",
    "It always seems impossible until it’s done. - Nelson Mandela",
    "You have power over your mind—not outside events. Realize this, and you will find strength. - Marcus Aurelius",
    "Change the way you look at things and the things you look at change. - Wayne Dyer",
    "Realize deeply that the present moment is all you have. - Eckhart Tolle",
    "Smile, breathe, and go slowly. - Thich Nhat Hanh",
    "Faith is taking the first step even when you don't see the whole staircase. - Martin Luther King Jr.",
    "What we think, we become. - Buddha",
    "The unexamined life is not worth living. - Socrates",
    "It does not matter how slowly you go as long as you do not stop. - Confucius",
    "Keep your face always toward the sunshine—and shadows will fall behind you. - Walt Whitman",
    "Your living is determined not so much by what life brings to you as by the attitude you bring to life. - Khalil Gibran",
]

func getRandomQuote() -> String {
    return quotes.randomElement() ?? "Relax, breathe, and take life one step at a time."
}

//  Quotes.swift
//  Soundscapes
//
//  Created by Josh Robertson on 10/9/24.
//

