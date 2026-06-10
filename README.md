# botanical-latin

A text file of California native plant names for macOS spell-check.

Copy the words into your Mac's personal dictionary once. After that, names like `Arctostaphylos` and `agrifolia` stop getting red squiggles in iA Writer, Notion, Notes, Mail, and most Mac apps.

Built from [iNaturalist](https://www.inaturalist.org/) data — 8,893 species, 15,551 entries including genera and epithets.

## Install

You only need **`dist/words.txt`**.

### 1. Get the word list

Download this repo (**Code** → **Download ZIP**) or grab [`dist/words.txt`](dist/words.txt) directly from GitHub.

### 2. Open your Mac's personal dictionary

1. Open **Finder**
2. Press **Cmd+Shift+G** (Go to Folder)
3. Paste this path and press **Return**:

```
~/Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling
```

4. Double-click **LocalDictionary** (opens in TextEdit)

If that folder is empty, try this path instead:

```
~/Library/Spelling
```

### 3. Paste the plant names

1. Open **`words.txt`** from this repo
2. **Cmd+A** → **Cmd+C** (select all, copy)
3. In **LocalDictionary**, click at the very end of the file
4. **Cmd+V** → **Cmd+S** (paste, save)

### 4. Restart your apps

Quit your writing apps fully (**Cmd+Q**), then reopen them.

Keep **System Settings → Keyboard → Text Input → Edit → Spelling** on **U.S.** or **Automatic by Language**.

## That's it

No app to install. No Keyboard language to switch. You are appending to a plain text file macOS already uses for spell-check.

Works anywhere that uses the system spell checker. **Notion in a browser** uses Chrome or Safari spell-check instead — use the Notion desktop app on Mac.

## Uninstall

Open **LocalDictionary** the same way (Cmd+Shift+G path above). Delete the plant names you pasted, or restore from a backup if you made one before editing.

To remove only what you added: search for a block of names you recognize from `words.txt`, select those lines, delete, save.

## Optional helpers

| File | What it does |
|------|----------------|
| `Manual Install.command` | Opens `words.txt` and the Spelling folder for you |
| `Install.command` | Automatic paste (needs Terminal Full Disk Access — usually blocked) |
| `Uninstall.command` | Removes names if automatic install succeeded |
| `scripts/build.py` | Rebuild `words.txt` from iNaturalist |

Most people should just use the manual steps above.

## Rebuild

```bash
python3 scripts/build.py
```

## Data

iNaturalist API — California native vascular plants (`place_id=14`, `taxon_id=47126`, `native=true`).

## License

MIT — see [LICENSE](LICENSE).
