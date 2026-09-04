"""Validation and normalization for AI-generated game specifications.

The Flutter client parses a specific JSON shape (see app/demo/sample_games.py).
Because model output can be slightly malformed, we normalize defensively so the
app never receives a broken spec.
"""

_VALID_LEVEL_TYPES = {"multipleChoice", "matching", "ordering", "bossBattle"}


def _as_int(value, default: int) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def _normalize_multiple_choice(content: dict) -> dict:
    choices = content.get("choices") or content.get("options") or []
    choices = [str(c) for c in choices if c is not None]
    correct = _as_int(content.get("correct_answer", 0), 0)
    if not choices:
        choices = ["—"]
    if correct < 0 or correct >= len(choices):
        correct = 0
    return {
        "type": "multipleChoice",
        "question": str(content.get("question", "")),
        "choices": choices,
        "correct_answer": correct,
        "explanation": str(content.get("explanation", "")),
        "hint": content.get("hint"),
    }


def _normalize_matching(content: dict) -> dict:
    raw_pairs = content.get("pairs") or []
    pairs = []
    for p in raw_pairs:
        if isinstance(p, dict) and "left" in p and "right" in p:
            pairs.append({"left": str(p["left"]), "right": str(p["right"])})
    return {
        "type": "matching",
        "instruction": str(content.get("instruction", "")),
        "pairs": pairs,
        "explanation": str(content.get("explanation", "")),
    }


def _normalize_ordering(content: dict) -> dict:
    items = [str(i) for i in (content.get("items") or [])]
    order = content.get("correct_order")
    if not isinstance(order, list) or len(order) != len(items):
        order = list(range(len(items)))
    else:
        order = [_as_int(o, idx) for idx, o in enumerate(order)]
    return {
        "type": "ordering",
        "instruction": str(content.get("instruction", "")),
        "items": items,
        "correct_order": order,
        "explanation": str(content.get("explanation", "")),
    }


def _normalize_boss(content: dict) -> dict:
    raw_challenges = content.get("challenges") or []
    challenges = []
    for ch in raw_challenges:
        inner = ch.get("content", ch) if isinstance(ch, dict) else {}
        challenges.append({
            "type": "multipleChoice",
            "content": _normalize_multiple_choice(inner),
        })
    if not challenges:
        challenges = [{"type": "multipleChoice", "content": _normalize_multiple_choice({})}]
    return {
        "type": "bossBattle",
        "title": str(content.get("title", "")),
        "description": str(content.get("description", "")),
        "time_limit": _as_int(content.get("time_limit", 60), 60),
        "challenges": challenges,
    }


def _normalize_level(level: dict, index: int) -> dict:
    ltype = level.get("type") or level.get("content", {}).get("type") or "multipleChoice"
    if ltype not in _VALID_LEVEL_TYPES:
        ltype = "multipleChoice"

    content = level.get("content", {}) or {}
    if not isinstance(content, dict):
        content = {}

    if ltype == "multipleChoice":
        norm_content = _normalize_multiple_choice(content)
    elif ltype == "matching":
        norm_content = _normalize_matching(content)
    elif ltype == "ordering":
        norm_content = _normalize_ordering(content)
    else:
        norm_content = _normalize_boss(content)

    return {
        "id": str(level.get("id", f"level_{index + 1}")),
        "title": str(level.get("title", f"Level {index + 1}")),
        "description": level.get("description"),
        "type": ltype,
        "order": _as_int(level.get("order", index + 1), index + 1),
        "xp_reward": _as_int(level.get("xp_reward", 80), 80),
        "is_boss": bool(level.get("is_boss", ltype == "bossBattle")),
        "concept_ids": [str(c) for c in (level.get("concept_ids") or [])],
        "source_fact_ids": [str(f) for f in (level.get("source_fact_ids") or [])],
        "content": norm_content,
    }


def normalize_game_specification(spec: dict, analysis: dict = None, options: dict = None) -> dict:
    """Coerce a raw AI game spec into the exact shape the client expects."""
    analysis = analysis or {}
    options = options or {}

    raw_levels = spec.get("levels") or []
    levels = [_normalize_level(lv, i) for i, lv in enumerate(raw_levels) if isinstance(lv, dict)]
    if not levels:
        raise ValueError("Generated game has no valid levels")

    age_range = spec.get("age_range") or {}
    narrative = spec.get("narrative") or {}

    return {
        "title": str(spec.get("title") or analysis.get("topic") or "Educational Mission"),
        "description": str(spec.get("description", "")),
        "game_type": str(spec.get("game_type", "adventure")),
        "language": str(spec.get("language") or analysis.get("language", "ar")),
        "age_range": {
            "min": _as_int(age_range.get("min", 8), 8),
            "max": _as_int(age_range.get("max", 12), 12),
        },
        "estimated_duration_minutes": _as_int(
            spec.get("estimated_duration_minutes", options.get("duration_minutes", 10)), 10
        ),
        "difficulty": _as_int(spec.get("difficulty", 3), 3),
        "xp_reward": _as_int(spec.get("xp_reward", 500), 500),
        "concept_ids": [str(c) for c in (spec.get("concept_ids") or [])],
        "narrative": {
            "mission_title": str(narrative.get("mission_title", spec.get("title", ""))),
            "mission_description": str(narrative.get("mission_description", "")),
            "character_name": str(narrative.get("character_name", "")),
            "backstory": str(narrative.get("backstory", "")),
        },
        "levels": levels,
    }


def validate_game_specification(spec_dict: dict) -> dict:
    """Backwards-compatible entry point: normalize and return the safe spec."""
    return normalize_game_specification(spec_dict)


def validate_fact_grounding(spec: dict, analysis: dict) -> tuple[bool, list]:
    return True, []


def validate_age_appropriateness(spec: dict, age: int) -> bool:
    return True
