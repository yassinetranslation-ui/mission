import anthropic
import json
import re
from app.config import get_settings
from app.demo.sample_analysis import sample_analyses
from app.demo.sample_games import sample_games
from app.ai.prompts.content_analysis import SYSTEM_PROMPT, build_content_analysis_prompt
from fastapi import HTTPException

class ClaudeService:
    def __init__(self):
        self.settings = get_settings()
        self.client = (
            anthropic.Anthropic(api_key=self.settings.claude_api_key)
            if self.settings.claude_api_key and not self.settings.demo_mode
            else None
        )

    def _extract_json(self, raw_text: str) -> dict:
        """Extract valid JSON from Claude output, stripping any markdown wrappers"""
        text = raw_text.strip()
        # Strip ```json ... ```
        if "```" in text:
            match = re.search(r"```(?:json)?\s*([\s\S]*?)\s*```", text)
            if match:
                text = match.group(1).strip()
        try:
            return json.loads(text)
        except json.JSONDecodeError:
            # Try to find the outermost braces
            start = text.find("{")
            end = text.rfind("}")
            if start != -1 and end != -1:
                return json.loads(text[start:end+1])
            raise ValueError(f"Could not parse JSON from Claude response: {raw_text[:200]}")

    def analyze_content(self, text_or_image_data: str, file_type: str = "image", child_age: int = 9, lesson_title: str = "") -> dict:
        """Analyze educational content using Claude or fallback to rich demo curriculum"""
        if self.settings.demo_mode or not self.client:
            # Select appropriate demo analysis based on title / text hints
            title_lower = (lesson_title or "").lower()
            text_lower = (text_or_image_data or "").lower()
            if "fraction" in title_lower or "math" in title_lower or "fraction" in text_lower:
                return sample_analyses[1]
            return sample_analyses[0]

        prompt = build_content_analysis_prompt(
            lesson_text=text_or_image_data,
            file_type=file_type,
            child_age=child_age
        )

        try:
            response = self.client.messages.create(
                model=self.settings.claude_model,
                max_tokens=self.settings.claude_max_tokens,
                system=SYSTEM_PROMPT,
                messages=[{"role": "user", "content": prompt}]
            )
            content = response.content[0].text
            return self._extract_json(content)
        except Exception as e:
            # If Claude fails, return sample analysis with log
            print(f"[ClaudeService Error] {str(e)} - falling back to demo analysis")
            return sample_analyses[0]

    def generate_game(self, analysis_data: dict, options: dict = None) -> dict:
        if self.settings.demo_mode or not self.client:
            if analysis_data.get("language") == "en":
                return sample_games[1]
            return sample_games[0]

        # Live game generation implemented in Phase 4
        return sample_games[0]

    def generate_practice(self, context: dict, prompt: str) -> dict:
        return sample_games[0]

    def generate_report_insight(self, data: dict, prompt: str) -> str:
        return "Your child showed strong mastery in core concepts, and is ready for the next level mission."

claude_service = ClaudeService()

def get_claude_service() -> ClaudeService:
    return claude_service
