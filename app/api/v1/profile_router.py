from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session

from database import get_db
from models import User, Skill, UserSkill
from app.api.v1.embedding_service import save_user_embedding

router = APIRouter(prefix="/profile", tags=["Profile"])


class ProfileSaveRequest(BaseModel):
    user_id: int
    full_name: str = ""
    about: str = ""
    experience: str = ""
    education: str = ""
    education_level: str = ""
    years_of_experience: str = ""
    skills: list[str] = []
    languages: list[str] = []
    location: str = ""


@router.post("/save")
def save_profile(
    payload: ProfileSaveRequest,
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == payload.user_id).first()

    if not user:
        return {"ok": False, "msg": "User not found"}

    user.full_name = payload.full_name
    user.about = payload.about
    user.experience = payload.experience
    user.education = payload.education
    user.education_level = payload.education_level
    user.years_of_experience = payload.years_of_experience
    user.languages = ", ".join(payload.languages)
    user.location = payload.location

    db.query(UserSkill).filter(UserSkill.user_id == payload.user_id).delete()

    for skill_name in payload.skills:
        clean_name = skill_name.strip().lower()
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
    db.refresh(user)

    save_user_embedding(db, user)

    return {
        "ok": True,
        "msg": "Profile saved successfully",
        "user_id": payload.user_id,
    }