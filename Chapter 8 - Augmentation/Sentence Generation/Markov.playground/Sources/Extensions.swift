import Foundation

// BEGIN markov_ext1
public extension Collection {
    func randomIndex() -> Int? {
        if self.isEmpty { return nil }
        return Int(arc4random_uniform(UInt32(self.count)))
    }
}
// END markov_ext1

// BEGIN markov_ext2
public extension NSRegularExpression {
    func matches(in text: String) -> [NSTextCheckingResult] {
        return self.matches(
            in: text, 
            range: NSRange(text.startIndex..., in: text)
        )
    }
}
// END markov_ext2

// BEGIN markov_ext3
public extension String {
    func matches(regex pattern: String) throws -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: self)
            return matches.map({ 
                String(self[Range($0.range, in: self)!]) 
            })
        } catch {
            throw error as Error
        }
    }
}
// END markov_ext3

// BEGIN markov_ext4
public extension String {
    static let sentenceEnd: String = "."
    
    func tokenize() -> [String] {
        var tokens: [String] = []

        let sentenceRegex = 
            "[^.!?\\s][^.!?]*(?:[.!?](?!['\"]?\\s[A-Z]|$)[^.!?]*)*" + 
                "[.!?]?['\"]?(?=\\s|$)"

        let wordRegex = "((\\b[^\\s]+\\b)((?<=\\.\\w).)?)"
        
        if let sentences = try? self.matches(regex: sentenceRegex) {
            for sentence in sentences {
                if let words = try? sentence.matches(regex: wordRegex),
                    !words.isEmpty {
                    tokens += words
                    tokens.append(String.sentenceEnd)
                }
            }
        }

        return tokens
    }
}
// END markov_ext4
