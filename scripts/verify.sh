#!/bin/bash
set -euo pipefail

osascript -l JavaScript -e '
ObjC.import("AppKit");
var c = $.NSSpellChecker.sharedSpellChecker;
var tests = ["Arctostaphylos", "Eriogonum", "agrifolia", "fasciculatum"];
var ok = 0;
for (var i = 0; i < tests.length; i++) {
  var w = tests[i];
  var r = c.checkSpellingOfStringStartingAtLanguageWrapInSpellDocumentWithTagWordCount(w, 0, "en", false, 0, null);
  var pass = String(r.location) === "9223372036854775807";
  if (pass) ok++;
  console.log(w + ": " + (pass ? "recognized" : "not recognized"));
}
if (ok !== tests.length) ObjC.import("stdlib").exit(1);
'
