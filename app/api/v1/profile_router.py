from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from fastapi import Query
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
    job_type: str = ""


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
    user.languages = ", ".join(payload.languages) if payload.languages else ""
    user.location = payload.location or ""
    user.job_type = payload.job_type or ""
    user.skill = ", ".join(payload.skills) if payload.skills else ""
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


@router.get("/search")
def search_users(
    job_type: str = Query(None),
    skill: str = Query(None),
    location: str = Query(None),
    db: Session = Depends(get_db),
):
    query = db.query(User)

    if job_type:
        query = query.filter(User.job_type.ilike(f"%{job_type}%"))

    if location:
        query = query.filter(User.location.ilike(f"%{location}%"))

    if skill:
        query = query.filter(User.skill.isnot(None))
        query = query.filter(User.skill.ilike(f"%{skill}%"))

    return query.all()

