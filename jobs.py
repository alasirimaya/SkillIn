from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Job
from app.api.v1.embedding_service import save_job_embedding

router = APIRouter(
    prefix="/jobs",
    tags=["Jobs"]
)


@router.post("/")
def create_job(
    title: str,
    company: str,
    workplace: str = "",
    location: str = "",
    employmentType: str = "",
    employment_type: str = "",
    education_requirement: str = "",
    experience_requirement: str = "",
    languages: str = "",
    description: str = "",
    skills: str = "",
    db: Session = Depends(get_db)
):
    final_employment_type = employmentType or employment_type

    new_job = Job(
        title=title,
        company=company,
        workplace=workplace,
        location=location,
        employment_type=final_employment_type,
        education_requirement=education_requirement,
        experience_requirement=experience_requirement,
        languages=languages,
        description=description,
        skills=skills
    )

    db.add(new_job)
    db.commit()
    db.refresh(new_job)

    try:
        save_job_embedding(db, new_job)
    except Exception as e:
        print("SAVE JOB EMBEDDING ERROR:", e)

    return {
        "id": new_job.id,
        "title": new_job.title,
        "company": new_job.company,
        "workplace": new_job.workplace,
        "location": new_job.location,
        "employment_type": new_job.employment_type,
        "education_requirement": new_job.education_requirement,
        "experience_requirement": new_job.experience_requirement,
        "languages": new_job.languages,
        "description": new_job.description,
        "skills": new_job.skills
    }


@router.get("/")
def get_all_jobs(db: Session = Depends(get_db)):
    jobs = db.query(Job).all()

    return [
        {
            "id": job.id,
            "title": job.title,
            "company": job.company,
            "workplace": job.workplace,
            "location": job.location,
            "employment_type": job.employment_type,
            "education_requirement": job.education_requirement,
            "experience_requirement": job.experience_requirement,
            "languages": job.languages,
            "description": job.description,
            "skills": job.skills
        }
        for job in jobs
    ]


@router.get("/{job_id}")
def get_job(job_id: int, db: Session = Depends(get_db)):
    job = db.query(Job).filter(Job.id == job_id).first()

    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    return {
        "id": job.id,
        "title": job.title,
        "company": job.company,
        "workplace": job.workplace,
        "location": job.location,
        "employment_type": job.employment_type,
        "education_requirement": job.education_requirement,
        "experience_requirement": job.experience_requirement,
        "languages": job.languages,
        "description": job.description,
        "skills": job.skills
    }