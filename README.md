# botanical-latin

California native plant names as a macOS spell-check dictionary. Stops correct botanical Latin from getting red squiggles while you write.

Built from [iNaturalist](https://www.inaturalist.org/) observation data for California native vascular plants.

| | |
|---|---|
| Scientific names | 8,893 |
| Dictionary entries | 10,930 |
| Last built | June 9th, 2026 |

## Install

1. Download [`botanical-latin.dic`](dist/botanical-latin.dic) and [`botanical-latin.aff`](dist/botanical-latin.aff) from the `dist/` folder
2. Copy both files to `~/Library/Spelling/`
   - Finder → hold **Option** → **Go** → **Library** → **Spelling**
   - Or **Go to Folder**: `~/Library/Spelling`
3. Restart your Mac (or quit and reopen your writing apps)
4. **System Settings** → **Keyboard** → **Text Input** → **Edit**
5. Open the **Spelling** dropdown → **Set Up...**
6. Check **botanical-latin (Library)** — keep **English** checked too
7. Click **Done**

In some apps (TextEdit, Pages): **Edit** → **Spelling and Grammar** → confirm the dictionary is active.

## What this does

- Correct scientific names like `Arctostaphylos manzanita` are treated as valid words
- Does **not** fix typos (`Arctistopheles` will still be flagged)
- Keep English enabled alongside botanical-latin so normal prose still spell-checks

"Automatic by Language" may not always catch Latin names mixed into English. You may need to set the spelling language per document in some apps.

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
