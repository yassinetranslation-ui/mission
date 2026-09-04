import os
import sys
import uuid

# Reconfigure stdout for Windows console UTF-8 support
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

from app.database import SessionLocal, create_tables
from app.models.user import User
from app.models.child import Child
from app.models.lesson import Lesson
from app.models.content_analysis import ContentAnalysis
from app.models.concept import Concept
from app.services.claude_service import get_claude_service
from app.schemas.auth import RegisterRequest
from app.services import auth_service

def test_phase3_pipeline():
    print("[START] Starting Phase 3 Integration Test...")
    create_tables()
    db = SessionLocal()

    # 1. Ensure a parent user exists
    user_email = f"parent_{uuid.uuid4().hex[:6]}@example.com"
    req = RegisterRequest(email=user_email, password="Password123!", name="Dr. Parent")
    auth_res = auth_service.register(db, req)
    user_id = auth_res.user.id
    print(f"[SUCCESS] 1. Created Parent User: {user_id}")

    # 2. Create a child
    child = Child(
        id=str(uuid.uuid4()),
        parent_id=user_id,
        name="Lina",
        age=9,
        preferred_language="ar",
        grade_level="4th Grade",
        preferred_subjects=["Science", "Math"]
    )
    db.add(child)
    db.commit()
    db.refresh(child)
    print(f"[SUCCESS] 2. Created Child: {child.name} (Age {child.age})")

    # 3. Create a mock uploaded lesson
    os.makedirs("./uploads", exist_ok=True)
    sample_file_path = "./uploads/test_science_lesson.txt"
    with open(sample_file_path, "w", encoding="utf-8") as f:
        f.write("درس دورة المياه في الطبيعة: التبخر والتكثف والهطول والتجمع وجريان المياه.")

    lesson = Lesson(
        id=str(uuid.uuid4()),
        parent_id=user_id,
        child_id=child.id,
        title="دورة المياه في الطبيعة",
        file_path=sample_file_path,
        file_type="image",
        status="uploaded"
    )
    db.add(lesson)
    db.commit()
    db.refresh(lesson)
    print(f"[SUCCESS] 3. Uploaded Lesson: {lesson.title} (ID: {lesson.id})")

    # 4. Run Claude Content Analysis
    claude_svc = get_claude_service()
    analysis_data = claude_svc.analyze_content(
        text_or_image_data="دورة المياه في الطبيعة",
        file_type="image",
        child_age=child.age,
        lesson_title=lesson.title
    )
    print(f"[SUCCESS] 4. AI Content Analysis Generated: Topic='{analysis_data.get('topic')}', Subject='{analysis_data.get('subject')}'")

    # 5. Save ContentAnalysis in DB
    analysis = ContentAnalysis(
        id=str(uuid.uuid4()),
        lesson_id=lesson.id,
        subject=analysis_data.get("subject"),
        topic=analysis_data.get("topic"),
        language=analysis_data.get("language", "ar"),
        estimated_grade=str(analysis_data.get("estimated_grade", "Grade 4")),
        difficulty=analysis_data.get("difficulty", "medium"),
        summary=analysis_data.get("summary"),
        concepts=analysis_data.get("concepts", {}),
        learning_objectives=analysis_data.get("learning_objectives", []),
        important_facts=analysis_data.get("important_facts", []),
        terminology=analysis_data.get("terminology", {}),
        potential_questions=analysis_data.get("potential_questions", []),
        prompt_version="1.0.0"
    )
    db.add(analysis)
    
    # Add concepts
    concepts_dict = analysis_data.get("concepts", {})
    for key, name in concepts_dict.items():
        c_rec = Concept(
            id=str(uuid.uuid4()),
            analysis_id=analysis.id,
            concept_key=str(key),
            name=str(name),
            description=str(name)
        )
        db.add(c_rec)

    lesson.status = "ready"
    db.commit()
    db.refresh(analysis)

    print(f"[SUCCESS] 5. Knowledge Map & Concepts Persisted in Database:")
    print(f"   - Concepts count: {len(analysis.concepts)}")
    print(f"   - Objectives count: {len(analysis.learning_objectives)}")
    print(f"   - Facts count: {len(analysis.important_facts)}")
    print("[DONE] Phase 3 Backend Test Passed Successfully!")

if __name__ == "__main__":
    test_phase3_pipeline()
