import AppKit
import Foundation

let args = CommandLine.arguments
let wordsPath: String
let dryRun: Bool

if args.contains("--dry-run") {
  dryRun = true
  wordsPath = args.first { $0 != "--dry-run" && !$0.hasPrefix("-") }
    ?? (args.count > 2 ? args[2] : "")
} else {
  dryRun = false
  wordsPath = args.count > 1 ? args[1] : ""
}

guard !wordsPath.isEmpty, FileManager.default.fileExists(atPath: wordsPath) else {
  fputs("Usage: learn.swift [--dry-run] /path/to/words.txt\n", stderr)
  exit(1)
}

let raw = try String(contentsOfFile: wordsPath, encoding: .utf8)
let words = Array(Set(raw.split(whereSeparator: \.isNewline).map(String.init).filter { !$0.isEmpty }))
  .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }

if dryRun {
  print("Would teach \(words.count) words from \(wordsPath)")
  exit(0)
}

print("Teaching \(words.count) plant names to macOS spell-check...")
print("")

let checker = NSSpellChecker.shared
let start = Date()
var taught = 0

for word in words {
  checker.learnWord(word)
  taught += 1
  if taught % 1000 == 0 || taught == words.count {
    let elapsed = Date().timeIntervalSince(start)
    fputs("\r  \(taught) / \(words.count)  (\(String(format: "%.0fs", elapsed)))", stderr)
  }
}

fputs("\n\n", stderr)

let tests = ["Arctostaphylos", "Eriogonum", "agrifolia"]
var passed = 0
for word in tests {
  let range = checker.checkSpelling(
    of: word,
    startingAt: 0,
    language: "en",
    wrap: false,
    inSpellDocumentWithTag: 0,
    wordCount: nil
  )
  let ok = range.location == NSNotFound
  if ok { passed += 1 }
  print("  \(word): \(ok ? "recognized" : "still flagged")")
}

print("")
if passed == tests.count {
  print("Success! \(taught) plant names added.")
} else {
  print("Finished teaching \(taught) words, but some checks did not pass.")
}
print("Quit and reopen any writing apps you have open.")
