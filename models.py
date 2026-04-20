from sqlalchemy import Column, Integer, String, Text, ForeignKey, DateTime, UniqueConstraint
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(120))
    email = Column(String(120), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)

    skills = relationship("UserSkill", back_populates="user")
    applications = relationship("Application", back_populates="user")


class Job(Base):
    __tablename__ = "jobs"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(150), nullable=False)
    company = Column(String(150), nullable=False)

    location = Column(String(150), default="")
    workplace = Column(String(100), default="")
    employment_type = Column(String(100), default="")

    description = Column(Text, default="")
    skills = Column(Text, default="")

    applications = relationship("Application", back_populates="job")


class Skill(Base):
    __tablename__ = "skills"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(80), unique=True, nullable=False)

    users = relationship("UserSkill", back_populates="skill")


class UserSkill(Base):
    __tablename__ = "user_skills"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    skill_id = Column(Integer, ForeignKey("skills.id"))

    user = relationship("User", back_populates="skills")
    skill = relationship("Skill", back_populates="users")

    __table_args__ = (
        UniqueConstraint("user_id", "skill_id", name="unique_user_skill"),
    )


class Application(Base):
    __tablename__ = "applications"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    job_id = Column(Integer, ForeignKey("jobs.id"))
    status = Column(String(30), default="applied")
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="applications")
    job = relationship("Job", back_populates="applications")

    __table_args__ = (
        UniqueConstraint("user_id", "job_id", name="unique_application"),
    )