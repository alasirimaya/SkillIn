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

    role = Column(String(30), default="personal")
    #new
    job_type = Column(String, default="")
    skill = Column(String, default="")
    location = Column(String, default="")
    #
    skills = relationship("UserSkill", back_populates="user")
    applications = relationship("Application", back_populates="user")

    embedding_data = relationship(
        "UserEmbedding",
        uselist=False,
        back_populates="user",
        cascade="all, delete-orphan",
    )
class HrProfile(Base):
    __tablename__ = "hr_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)

    profile_picture = Column(Text, default="")
    full_name = Column(String(120), default="")
    job_title = Column(String(120), default="")
    work_email = Column(String(120), default="")
    phone_number = Column(String(50), default="")
    office_location = Column(String(150), default="")
    bio = Column(Text, default="")

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

    embedding_data = relationship(
        "JobEmbedding",
        uselist=False,
        back_populates="job",
        cascade="all, delete-orphan",
    )


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

    status = Column(String(30), default="Under Review")
    info = Column(Text, default="")
    cv_filename = Column(String(255), default="")
    cv_data = Column(Text, default="")

    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="applications")
    job = relationship("Job", back_populates="applications")

    __table_args__ = (
        UniqueConstraint("user_id", "job_id", name="unique_application"),
    )

class UserEmbedding(Base):
    __tablename__ = "user_embeddings"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)
    embedding = Column(Text, nullable=False)

    user = relationship("User", back_populates="embedding_data")


class JobEmbedding(Base):
    __tablename__ = "job_embeddings"

    id = Column(Integer, primary_key=True, index=True)
    job_id = Column(Integer, ForeignKey("jobs.id"), unique=True, nullable=False)
    embedding = Column(Text, nullable=False)

    job = relationship("Job", back_populates="embedding_data")