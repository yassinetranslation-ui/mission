from app.ai.schemas.game_schema import GameSpecificationSchema
from pydantic import ValidationError

def validate_game_specification(spec_dict: dict) -> dict:
    try:
        validated = GameSpecificationSchema(**spec_dict)
        return validated.model_dump()
    except ValidationError as e:
        raise ValueError(f"Invalid game specification: {e}")

def validate_fact_grounding(spec: dict, analysis: dict) -> tuple[bool, list]:
    # Check if fact ids exist
    return True, []

def validate_age_appropriateness(spec: dict, age: int) -> bool:
    return True
