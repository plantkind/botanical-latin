# botanical-latin

A text file of California native plant names for macOS spell-check.

Copy the words into your Mac's personal dictionary once. After that, names like `Arctostaphylos` and `agrifolia` stop getting red squiggles in iA Writer, Notion, Notes, Mail, and most Mac apps.

Built from [iNaturalist](https://www.inaturalist.org/) data — 8,893 species, 15,551 entries including genera and epithets.

## Install

You only need **`dist/words.txt`**.

### 1. Get the word list

Download this repo (**Code** → **Download ZIP**) or grab [`dist/words.txt`](dist/words.txt) from GitHub.

### 2. Open your Mac's personal dictionary

**Important:** On modern macOS (Sonoma and later), the file moved. Use this path — not `~/Library/Spelling/`.

1. Open **Finder**
2. Press **Cmd+Shift+G**
3. Paste this path and press **Return**:

```
~/Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling
```

4. Double-click **LocalDictionary** (opens in TextEdit)

### 3. Paste the plant names

1. Open **`words.txt`** from this repo
2. **Cmd+A** → **Cmd+C**
3. In **LocalDictionary**, click at the very end (or **Cmd+A** to replace all if this is a fresh Mac)
4. **Cmd+V** → **Cmd+S**

### 4. Restart spell-check

Pick one:

- **Restart your Mac** (most reliable the first time), or
- Quit iA Writer and other writing apps fully (**Cmd+Q**), then reopen

Keep **System Settings → Keyboard → Text Input → Edit → Spelling** on **U.S.** or **Automatic by Language**.

### Wrong folder?

If you pasted into `~/Library/Spelling/LocalDictionary` instead, macOS will ignore it. Use the **Group Containers** path above.

## That's it

No app to install. No Keyboard language to switch. You are editing a plain text file macOS already uses for spell-check.

Works anywhere that uses the system spell checker. **Notion in a browser** uses Chrome or Safari spell-check instead — use the Notion desktop app on Mac.

## Uninstall

Open **LocalDictionary** via the Group Containers path above. Delete the plant names you added, save.

## Optional helpers

| File | What it does |
|------|----------------|
| `dist/words.txt` | The word list — this is the main deliverable |
| `Manual Install.command` | Opens `words.txt` and the Spelling folder |
| `scripts/build.py` | Rebuild `words.txt` from iNaturalist |

## Rebuild

```bash
python3 scripts/build.py
```

## Data

iNaturalist API — California native vascular plants (`place_id=14`, `taxon_id=47126`, `native=true`).

## License

MIT — see [LICENSE](LICENSE).
