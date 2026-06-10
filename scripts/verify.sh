#!/bin/bash
set -euo pipefail

swift -e '
import AppKit
let c = NSSpellChecker.shared
let tests = ["Arctostaphylos", "Eriogonum", "agrifolia", "fasciculatum"]
var ok = 0
for w in tests {
  let r = c.checkSpelling(of: w, startingAt: 0, language: "en", wrap: false, inSpellDocumentWithTag: 0, wordCount: nil)
  let pass = r.location == NSNotFound
  if pass { ok += 1 }
  print("\(w): \(pass ? "recognized" : "not recognized")")
}
exit(ok == tests.count ? 0 : 1)
'
