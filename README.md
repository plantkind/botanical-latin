# botanical-latin

California native plant names for macOS spell-check. Stops correct botanical Latin from getting red squiggles in iA Writer, Notion, Notes, Mail, and most Mac apps.

Built from [iNaturalist](https://www.inaturalist.org/) data for California native vascular plants.

| | |
|---|---|
| Plant names | 8,893 species |
| Dictionary entries | 15,551 (includes genera and epithets like `agrifolia`) |
| Last built | June 9th, 2026 |

## How it works

macOS keeps a personal word list called **LocalDictionary** — a plain text file, one word per line. Words you right-click and "Learn Spelling" go here.

This project adds California native plant names to that same list. Your spelling language stays **U.S. English** (or Automatic by Language). English still works; plant names stop getting flagged.

This is the most universal approach on Mac. Any app that uses the system spell checker benefits — not just one editor.

**Not covered:** Notion in a web browser (uses Chrome or Safari spell-check, not macOS). Use the Notion desktop app instead.

## Install (for friends)

1. Download this repo from GitHub (green **Code** button → **Download ZIP**)
2. Unzip
3. Double-click **`Install.command`**
4. Quit and reopen your writing apps

No Terminal typing required. macOS may ask you to approve running the script once — click Open.

Keep **System Settings → Keyboard → Text Input → Edit → Spelling** on **U.S.** or **Automatic by Language**. Do not switch to botanical-latin (Library).

## Uninstall

Double-click **`Uninstall.command`**. Removes only the plant names this installer added — not your own learned words.

Before every install, a backup is saved next to LocalDictionary as `LocalDictionary.backup-botanical-latin`. You can open that file in TextEdit and restore by hand if you ever want to.

## Is it safe?

Yes. LocalDictionary is just a text file on your Mac:

```
~/Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary
```

- Fully reversible via **Uninstall.command**
- Backup created on install
- Only adds names; does not change Keyboard settings or replace English
- Tracks what it added in `~/Library/Application Support/botanical-latin/`

## Files

| File | Purpose |
|------|---------|
| `dist/words.txt` | Plain word list (for manual install or inspection) |
| `Install.command` | Double-click installer |
| `Uninstall.command` | Double-click uninstaller |
| `dist/botanical-latin.dic` | Hunspell format (optional; not recommended for most users) |

## Rebuild

```bash
python3 scripts/build.py
```

## Data source

iNaturalist API — California (`place_id=14`), native plants, `taxon_id=47126` (Plantae).

## License

MIT — see [LICENSE](LICENSE).
