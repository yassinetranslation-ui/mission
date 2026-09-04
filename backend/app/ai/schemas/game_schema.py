from pydantic import BaseModel
from typing import List, Optional, Dict, Any, Union

class LevelContentSchema(BaseModel):
    type: str
    question: Optional[str] = None
    options: Optional[List[str]] = None
    correct_answer: Optional[Union[str, List[str], int, List[int]]] = None
    explanation: Optional[str] = None
    concept_ids: Optional[List[str]] = None
    source_fact_ids: Optional[List[str]] = None
    # Can be extended for other types

class GameLevelSchema(BaseModel):
    id: str
    title: str
    description: str
    content: List[LevelContentSchema]

class GameSpecificationSchema(BaseModel):
    title: str
    description: str
    narrative_framing: str
    game_type: str
    difficulty: str
    levels: List[GameLevelSchema]
