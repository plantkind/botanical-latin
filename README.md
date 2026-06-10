# botanical-latin

California native plant names as a macOS spell-check dictionary. Stops correct botanical Latin from getting red squiggles while you write.

Built from [iNaturalist](https://www.inaturalist.org/) observation data for California native vascular plants.

| | |
|---|---|
| Scientific names | 8,893 |
| Dictionary entries | 15,551 |
| Last built | June 9th, 2026 |

## Install

### Quick install (recommended)

```bash
./scripts/install.sh
```

This copies the Hunspell files to `~/Library/Spelling/` and merges plant names into `LocalDictionary` (needed for **Obsidian** and some other Electron apps).

### Manual install

1. Download [`botanical-latin.dic`](dist/botanical-latin.dic) and [`botanical-latin.aff`](dist/botanical-latin.aff) from the `dist/` folder
2. Copy both files to `~/Library/Spelling/`
   - Finder → hold **Option** → **Go** → **Library** → **Spelling**
   - Or **Go to Folder**: `~/Library/Spelling`
3. **Restart your Mac** — this step matters; quitting apps alone is often not enough the first time
4. **System Settings** → **Keyboard** → **Text Input** → **Edit**
5. Leave **Spelling** set to **Automatic by Language** (do not pick botanical-latin alone here)
6. Open the **Spelling** dropdown → **Set Up...**
7. Check **both** boxes:
   - **U.S.** (or your English variant)
   - **botanical-latin (Library)**
8. Click **Done**, then **Done** again to close the panel

### English and Latin together

You do not switch the dropdown to botanical-latin. That would turn off normal English checking.

**Automatic by Language** plus both boxes checked in **Set Up...** tells macOS to accept a word if it is valid in **either** dictionary. English prose still gets spell-checked; botanical names stop getting flagged.

If a name is still underlined after setup, quit and reopen that app. Obsidian in particular needs a full quit (Cmd+Q), not just closing the window.

## What this does

- Correct scientific names like `Arctostaphylos` and `fasciculatum` are treated as valid words
- Does **not** fix typos (`Arctistopheles` will still be flagged)
- Does **not** replace English — keep U.S. checked in Set Up

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| botanical-latin appears in the list but names are still red | Open **Set Up...** and make sure the checkbox next to botanical-latin is on, not just highlighted in the menu |
| English stops getting checked | You selected botanical-latin alone in the Spelling dropdown — switch back to **Automatic by Language** and use Set Up instead |
| Works in TextEdit but not Obsidian | Run `./scripts/install.sh` — Obsidian uses `LocalDictionary`, not Hunspell files. Then quit Obsidian fully (Cmd+Q) and reopen |
| Genus works, epithet does not | Re-run `./scripts/install.sh` after pulling latest — epithets like `agrifolia` and `fasciculatum` are included as separate words |

## Rebuild

Requires Python 3 and network access.

```bash
python3 scripts/build.py
```

Pass `--full` to also fetch subspecies, varieties, and hybrids (slower; may hit iNaturalist rate limits).

## Data

Species list from the iNaturalist API:

```
GET /v1/observations/species_counts
  ?place_id=14
  &taxon_id=47126
  &native=true
```

Please follow [iNaturalist API recommended practices](https://www.inaturalist.org/pages/developers).

## License

MIT — see [LICENSE](LICENSE).
