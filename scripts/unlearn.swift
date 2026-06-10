import AppKit
import Foundation

let wordsPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""

guard !wordsPath.isEmpty, FileManager.default.fileExists(atPath: wordsPath) else {
  fputs("Usage: unlearn.swift /path/to/words.txt\n", stderr)
  exit(1)
}

let raw = try String(contentsOfFile: wordsPath, encoding: .utf8)
let words = Array(Set(raw.split(whereSeparator: \.isNewline).map(String.init).filter { !$0.isEmpty }))

print("Removing \(words.count) plant names from macOS spell-check...")
print("")

let checker = NSSpellChecker.shared
var removed = 0

for word in words {
  checker.forgetWord(word)
  removed += 1
  if removed % 1000 == 0 || removed == words.count {
    fputs("\r  \(removed) / \(words.count)", stderr)
  }
}

fputs("\n\n", stderr)
print("Removed \(removed) plant names.")
print("Quit and reopen any writing apps you have open.")
