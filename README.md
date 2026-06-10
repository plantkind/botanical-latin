# botanical-latin

Stop red squiggles on California native plant names while you write.

Double-click one file. About 10 seconds later, macOS spell-check recognizes names like `Arctostaphylos`, `Eriogonum`, and `agrifolia` — in iA Writer, Notion, Notes, Mail, and most Mac apps that use system spell-check.

**15,551 entries** · **8,893 species** · built from [iNaturalist](https://www.inaturalist.org/) California native plant data

## Install

1. Download this repo (**Code** → **Download ZIP**)
2. Double-click **`Install.command`**
3. Wait for the success message (~10 seconds)
4. Quit and reopen any writing apps you already have open

No Terminal. No Keyboard settings to change. No account to create.

macOS may ask you to confirm opening the installer the first time — that is normal for downloaded `.command` files.

## What it does

`Install.command` teaches macOS the same way **Learn Spelling** does when you right-click a word — once per plant name, automatically, for the full list.

Pasting `words.txt` into `LocalDictionary` by hand does **not** work for bulk adds on modern macOS. The words show up in the file, but spell-check keeps flagging them. This installer uses the system API that actually sticks.

## Works in

- iA Writer
- Notion (desktop app)
- Notes, Mail, Pages, TextEdit
- Most Mac apps that use system spell-check

**Notion in a browser** uses Chrome or Safari spell-check instead — use the desktop app on Mac.

## Files

| File | Purpose |
|------|---------|
| `Install.command` | Run this to install |
| `Learn Words.command` | Same installer, different name |
| `dist/words.txt` | The word list |
| `Uninstall.command` | Remove all plant names from spell-check |
| `scripts/build.py` | Rebuild `words.txt` from iNaturalist |

## Uninstall

Double-click **`Uninstall.command`**, then quit and reopen your writing apps.

## Rebuild

```bash
python3 scripts/build.py
```

Pass `--full` to include infraspecific ranks (slower, more API calls).

## Data

iNaturalist API — California native vascular plants (`place_id=14`, `taxon_id=47126`, `native=true`).

## License

MIT — see [LICENSE](LICENSE).
