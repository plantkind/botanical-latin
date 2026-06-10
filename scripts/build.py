#!/usr/bin/env python3
"""Build words.txt from iNaturalist California native plant taxa."""

from __future__ import annotations

import json
import re
import time
import urllib.error
import urllib.request
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "dist"
USER_AGENT = "botanical-latin/1.0 (spell-check dictionary build)"
CALIFORNIA_PLACE_ID = 14
PLANTAE_TAXON_ID = 47126
NATIVE_MEANS = {"native", "endemic"}
RANKS = ("subspecies", "variety", "hybrid")
REQUEST_DELAY_SEC = 1.5


def fetch_json(url: str, retries: int = 5) -> dict:
    for attempt in range(retries):
        request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
        try:
            with urllib.request.urlopen(request, timeout=120) as response:
                return json.load(response)
        except urllib.error.HTTPError as error:
            if error.code in {403, 429, 500, 502, 503, 504} and attempt < retries - 1:
                time.sleep(REQUEST_DELAY_SEC * (attempt + 2))
                continue
            raise
        except urllib.error.URLError:
            if attempt < retries - 1:
                time.sleep(REQUEST_DELAY_SEC * (attempt + 2))
                continue
            raise
    raise RuntimeError(f"Failed to fetch {url}")


def is_native_in_california(taxon: dict) -> bool:
    preferred = taxon.get("preferred_establishment_means")
    if isinstance(preferred, str) and preferred in NATIVE_MEANS:
        return True

    establishment = taxon.get("establishment_means")
    if isinstance(establishment, str) and establishment in NATIVE_MEANS:
        return True

    if isinstance(establishment, dict):
        place = establishment.get("place") or {}
        if place.get("id") == CALIFORNIA_PLACE_ID:
            means = establishment.get("establishment_means")
            if isinstance(means, str) and means in NATIVE_MEANS:
                return True

    return False


def normalize_name(name: str) -> str:
    cleaned = re.sub(r"\s+", " ", name.strip())
    cleaned = cleaned.replace("×", "×").replace(" x ", " × ")
    return cleaned


def name_variants(name: str) -> set[str]:
    variants = {normalize_name(name)}
    without_periods = name.replace("ssp.", "ssp").replace("subsp.", "subsp").replace("var.", "var")
    variants.add(normalize_name(without_periods))
    return {variant for variant in variants if variant}


def paginate(url_base: str) -> list[dict]:
    page = 1
    results: list[dict] = []
    total_results = None

    while True:
        separator = "&" if "?" in url_base else "?"
        url = f"{url_base}{separator}per_page=200&page={page}"
        payload = fetch_json(url)
        batch = payload.get("results", [])
        if total_results is None:
            total_results = payload.get("total_results", 0)

        if not batch:
            break

        results.extend(batch)
        if page * 200 >= total_results:
            break

        page += 1
        time.sleep(REQUEST_DELAY_SEC)

    return results


def harvest_species_counts() -> set[str]:
    base = (
        "https://api.inaturalist.org/v1/observations/species_counts"
        f"?place_id={CALIFORNIA_PLACE_ID}&taxon_id={PLANTAE_TAXON_ID}&native=true"
    )
    names: set[str] = set()
    for row in paginate(base):
        taxon = row.get("taxon") or {}
        name = taxon.get("name")
        if isinstance(name, str) and name.strip():
            names.add(name.strip())
    return names


def harvest_rank(rank: str) -> set[str]:
    base = (
        "https://api.inaturalist.org/v1/taxa"
        f"?place_id={CALIFORNIA_PLACE_ID}&taxon_id={PLANTAE_TAXON_ID}"
        f"&rank={rank}&is_active=true"
    )
    names: set[str] = set()
    for taxon in paginate(base):
        if is_native_in_california(taxon):
            name = taxon.get("name")
            if isinstance(name, str) and name.strip():
                names.add(name.strip())
    return names


def expand_entries(scientific_names: set[str]) -> set[str]:
    entries: set[str] = set()
    rank_markers = {"var", "var.", "ssp", "ssp.", "subsp", "subsp.", "×", "x"}

    for name in scientific_names:
        entries.update(name_variants(name))
        parts = name.split()
        if not parts:
            continue

        entries.add(parts[0])
        for part in parts[1:]:
            if part.lower() not in rank_markers:
                entries.add(part)

    for token in ("var", "ssp", "subsp", "×"):
        entries.add(token)

    return {entry for entry in entries if entry}


def write_words(entries: set[str]) -> Path:
    DIST.mkdir(parents=True, exist_ok=True)
    words_path = DIST / "words.txt"
    words = sorted(entries, key=str.casefold)
    words_path.write_text("\n".join(words) + "\n", encoding="utf-8")
    return words_path


def main() -> None:
    import sys

    include_infraspecific = "--full" in sys.argv

    print("Fetching California native plant species from iNaturalist...")
    names = harvest_species_counts()
    print(f"  species: {len(names)}")

    if include_infraspecific:
        for rank in RANKS:
            print(f"Fetching native {rank}...")
            rank_names = harvest_rank(rank)
            print(f"  {rank}: {len(rank_names)}")
            names.update(rank_names)
    else:
        print("Skipping infraspecific ranks (pass --full to include; slower, rate-limited).")

    entries = expand_entries(names)
    words_path = write_words(entries)

    metadata = {
        "built_on": date.today().isoformat(),
        "source": "iNaturalist API",
        "scientific_names": len(names),
        "dictionary_entries": len(entries),
    }
    (DIST / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")

    print(f"Wrote {words_path} ({len(entries)} entries)")
    print(json.dumps(metadata, indent=2))


if __name__ == "__main__":
    main()
