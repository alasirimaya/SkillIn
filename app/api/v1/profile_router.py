from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from database import get_db
from models import User, Skill, UserSkill

router = APIRouter(prefix="/profile", tags=["Profile"])


class ProfileSaveRequest(BaseModel):
    user_id: int
    full_name: str = ""
    skills: list[str] = []


@router.post("/save")
def save_profile(
    payload: ProfileSaveRequest,
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == payload.user_id).first()

    if not user:
        return {"ok": False, "msg": "User not found"}

    if payload.full_name:
        user.full_name = payload.full_name

    db.query(UserSkill).filter(UserSkill.user_id == payload.user_id).delete()

    for skill_name in payload.skills:
        clean_name = skill_name.strip()
        if not clean_name:
            continue

        skill = db.query(Skill).filter(Skill.name == clean_name).first()

        if not skill:
            skill = Skill(name=clean_name)
            db.add(skill)
            db.commit()
            db.refresh(skill)

        db.add(UserSkill(user_id=payload.user_id, skill_id=skill.id))

    db.commit()

    return {
        "ok": True,
        "msg": "Profile saved successfully",
        "user_id": payload.user_id,
        "skills": payload.skills,
    }