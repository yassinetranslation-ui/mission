from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy.future import select
from typing import List
from app.database import get_db
from app.schemas.child import CreateChildRequest, UpdateChildRequest, ChildResponse, ChildListResponse
from app.models.user import User
from app.models.child import Child
from app.api.middleware.auth_middleware import get_current_user

router = APIRouter()

@router.post("/", response_model=ChildResponse, status_code=status.HTTP_201_CREATED)
async def create_child(request: CreateChildRequest, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Create a new child profile"""
    new_child = Child(
        parent_id=current_user.id,
        name=request.name,
        age=request.age,
        avatar=request.avatar,
        preferred_language=request.preferred_language,
        grade_level=request.grade_level,
        preferred_subjects=request.preferred_subjects
    )
    db.add(new_child)
    db.commit()
    db.refresh(new_child)
    return new_child

@router.get("/", response_model=ChildListResponse)
async def list_children(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """List all children for the current user"""
    result = db.execute(select(Child).where(Child.parent_id == current_user.id))
    children = result.scalars().all()
    return {"children": children}

@router.get("/{child_id}", response_model=ChildResponse)
async def get_child(child_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Get a specific child profile"""
    result = db.execute(select(Child).where(Child.id == child_id, Child.parent_id == current_user.id))
    child = result.scalars().first()
    if not child:
        raise HTTPException(status_code=404, detail="Child not found")
    return child

@router.put("/{child_id}", response_model=ChildResponse)
async def update_child(child_id: str, request: UpdateChildRequest, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Update a specific child profile"""
    result = db.execute(select(Child).where(Child.id == child_id, Child.parent_id == current_user.id))
    child = result.scalars().first()
    if not child:
        raise HTTPException(status_code=404, detail="Child not found")
    
    update_data = request.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(child, key, value)
        
    db.commit()
    db.refresh(child)
    return child

@router.delete("/{child_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_child(child_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Delete a child profile"""
    result = db.execute(select(Child).where(Child.id == child_id, Child.parent_id == current_user.id))
    child = result.scalars().first()
    if not child:
        raise HTTPException(status_code=404, detail="Child not found")
        
    db.delete(child)
    db.commit()
    return None
