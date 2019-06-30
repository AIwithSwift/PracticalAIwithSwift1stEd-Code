import Foundation

class MarkovChain {

    private let startWords: [String]
    private let links: [String: [Link]]

    private(set) var sequence: [String] = []

    enum Link: Equatable {
        case end
        case word(options: [String])
        
        var words: [String] {
            switch self {
                case .end: return []
                case .word(let words): return words
            }
        }
    }

    init?(with inputFilepath: String) {
        guard let filePath = Bundle.main.path(forResource: inputFilepath, ofType: ".txt"),
            let inputFile = FileManager.default.contents(atPath: filePath),
            let inputString = String(data: inputFile, encoding: .utf8) else { return nil }
        print("File imported successfully!")
        let tokens = inputString.tokenize()
        
        var startWords: [String] = []
        var links: [String: [Link]] = [:]
        
        // for word or sentence end in intput
        for index in 0..<tokens.count - 1 {
            let thisToken = tokens[index]
            let nextToken = tokens[index + 1]
            
            // if this is a sentence end followed by a word
            // that word is a starter word
            if thisToken == String.sentenceEnd {
                startWords.append(nextToken)
                continue
            }
            
            var tokenLinks = links[thisToken, default: []]
            
            // if this is a word followed by a sentence end
            // add 'end' to this word's links
            if nextToken == String.sentenceEnd {
                if !tokenLinks.contains(.end) {
                    tokenLinks.append(.end)
                }
                
                links[thisToken] = tokenLinks
                continue
            }
            
            // if this is a word followed by a word
            // add this word to the word's word link options
            let wordLinkIndex = tokenLinks.firstIndex(where: { element in
                if case .word = element {
                    return true
                }
                return false
            })
            
            var options: [String] = []
            if let index = wordLinkIndex {
                options = tokenLinks[index].words
                tokenLinks.remove(at: index)
            }
        
            options.append(nextToken)
            tokenLinks.append(.word(options: options))
            links[thisToken] = tokenLinks
        }

        self.links = links
        self.startWords = startWords
        
        // if the input was one or less sentences,
        // this is going to be a useless chain
        if startWords.isEmpty { return nil }
        
        print("Model initiated successfully!")
    }

    func clear() {
        self.sequence = []
    }

    func nextWord() -> String {
        let newWord: String
        
        // if there was no last token or it was a sentence end, get a randon new word
        if self.sequence.isEmpty || self.sequence.last == String.sentenceEnd {
            newWord = startWords.randomElement()! // can't be empty, else this object would be nil
        } else {
            // otherwise get a random new token to follow the last word
            let lastWord = self.sequence.last! // can't be empty, else the above .isEmpty would have been true

            // get random word or sentence end
            let link = links[lastWord]?.randomElement()
            newWord = link?.words.randomElement() ?? "."
        }
        
        self.sequence.append(newWord)
        return newWord
    }
    
    func generate(wordCount: Int = 100) -> String {
        // get n words, put them together
        for _ in 0..<wordCount { let _ = self.nextWord() }
        return self.sequence.joined(separator: " ").replacingOccurrences(of: " .", with: ".")
    }
}

let file = "wonderland"
if let markovChain = MarkovChain(with: file) {
    print("\n BEGIN TEXT\n==========\n")
    print(markovChain.generate())
    print("\n==========\n END TEXT\n")
} else {
    print("Failure")
}
