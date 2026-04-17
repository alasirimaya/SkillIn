from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from database import get_db
from models import User

router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/personal")
def get_personal_users(db: Session = Depends(get_db)):

    users = db.query(User).filter(User.role == "personal").all()

    return [
        {
            "id": u.id,
            "full_name": u.full_name,
            "email": u.email,
            "location": getattr(u, "location", ""),
            "skill": getattr(u, "skill", ""),
            "job_type": getattr(u, "job_type", ""),
        }
        for u in users
    ]