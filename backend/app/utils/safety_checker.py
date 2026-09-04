def check_content_safety(text: str) -> tuple[bool, str]:
    # Basic keyword filtering
    unsafe_keywords = ["violence", "hate"]
    for word in unsafe_keywords:
        if word in text.lower():
            return False, f"Found unsafe keyword: {word}"
    return True, ""
