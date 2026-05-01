import json
import re
import torch
from torch.nn.functional import cosine_similarity


def _to_tensor(embedding):
    if embedding is None:
        return None

    if isinstance(embedding, str):
        embedding = json.loads(embedding)

    return torch.tensor(embedding, dtype=torch.float32)


def _normalize(text):
    return (text or "").lower().replace("-", " ").strip()


def _split_list(text):
    if not text:
        return set()

    parts = re.split(r"[,;/|\n]+", text)

    return {
        _normalize(item)
        for item in parts
        if _normalize(item)
    }


def _get_user_skills(user):
    skills = set()

    for user_skill in user.skills:
        if user_skill.skill and user_skill.skill.name:
            skills.add(_normalize(user_skill.skill.name))

    return skills


def _get_user_languages(user):
    return _split_list(getattr(user, "languages", ""))


def _get_user_profile_text(user):
    parts = [
        getattr(user, "full_name", ""),
        getattr(user, "education_level", ""),
        getattr(user, "education", ""),
        getattr(user, "years_of_experience", ""),
        getattr(user, "about", ""),
        getattr(user, "experience", ""),
        getattr(user, "languages", ""),
        getattr(user, "location", ""),
    ]

    skills_text = ", ".join(_get_user_skills(user))
    parts.append(skills_text)

    return _normalize(" ".join(parts))


def _skill_score(user_skills, job_skills):
    if not job_skills:
        return None

    matched = user_skills.intersection(job_skills)
    return len(matched) / len(job_skills)


def _education_level_score(user_education_level, job_education_requirement):
    user_level = _normalize(user_education_level)
    job_level = _normalize(job_education_requirement)

    if not job_level:
        return None

    if not user_level:
        return 0.0

    education_rank = {
        "high school": 1,
        "diploma": 2,
        "bachelor": 3,
        "master": 4,
        "phd": 5,
    }

    user_rank = education_rank.get(user_level, 0)
    job_rank = education_rank.get(job_level, 0)

    if job_rank == 0:
        return None

    return 1.0 if user_rank >= job_rank else 0.0


def _experience_score(user_years, job_experience_requirement):
    user_exp = _normalize(user_years)
    job_exp = _normalize(job_experience_requirement)

    if not job_exp:
        return None

    if not user_exp:
        return 0.0

    experience_rank = {
        "0 1 years": 1,
        "1 3 years": 2,
        "3 5 years": 3,
        "5+ years": 4,
        "5 years": 4,
    }

    user_rank = experience_rank.get(user_exp, 0)
    job_rank = experience_rank.get(job_exp, 0)

    if job_rank == 0:
        return None

    return 1.0 if user_rank >= job_rank else 0.0


def _language_score(user_languages, job_languages):
    if not job_languages:
        return None

    if not user_languages:
        return 0.0

    matched = user_languages.intersection(job_languages)
    return len(matched) / len(job_languages)


def _location_score(user_location, job_location):
    user_location = _normalize(user_location)
    job_location = _normalize(job_location)

    if not job_location:
        return None

    if not user_location:
        return 0.0

    return 1.0 if job_location in user_location or user_location in job_location else 0.0


def recommend_for_user(user, jobs):
    recommendations = []

    user_skills = _get_user_skills(user)
    user_languages = _get_user_languages(user)
    user_text = _get_user_profile_text(user)

    user_education_level = getattr(user, "education_level", "")
    user_years_of_experience = getattr(user, "years_of_experience", "")
    user_location = getattr(user, "location", "")

    user_emb = None
    if user.embedding_data and user.embedding_data.embedding:
        user_emb = _to_tensor(user.embedding_data.embedding)

    for job in jobs:
        job_skills = _split_list(job.skills)
        job_languages = _split_list(getattr(job, "languages", ""))

        job_text = _normalize(
            f"{job.title} "
            f"{job.company} "
            f"{job.description} "
            f"{job.skills} "
            f"{getattr(job, 'education_requirement', '')} "
            f"{getattr(job, 'experience_requirement', '')} "
            f"{getattr(job, 'languages', '')} "
            f"{job.location} "
            f"{job.workplace} "
            f"{job.employment_type}"
        )

        weighted_scores = []

        skill_match = _skill_score(user_skills, job_skills)
        if skill_match is not None:
            weighted_scores.append((skill_match, 0.40))

        education_match = _education_level_score(
            user_education_level,
            getattr(job, "education_requirement", ""),
        )
        if education_match is not None:
            weighted_scores.append((education_match, 0.18))

        experience_match = _experience_score(
            user_years_of_experience,
            getattr(job, "experience_requirement", ""),
        )
        if experience_match is not None:
            weighted_scores.append((experience_match, 0.20))

        language_match = _language_score(user_languages, job_languages)
        if language_match is not None:
            weighted_scores.append((language_match, 0.10))

        location_match = _location_score(user_location, job.location)
        if location_match is not None:
            weighted_scores.append((location_match, 0.12))

        embedding_score = 0.0
        if user_emb is not None and job.embedding_data and job.embedding_data.embedding:
            job_emb = _to_tensor(job.embedding_data.embedding)

            embedding_score = cosine_similarity(
                user_emb.unsqueeze(0),
                job_emb.unsqueeze(0),
            ).item()

            embedding_score = max(0.0, min(1.0, embedding_score))

        if weighted_scores:
            total_weight = sum(weight for _, weight in weighted_scores)
            requirements_score = (
                sum(score * weight for score, weight in weighted_scores)
                / total_weight
            )

            similarity = (requirements_score * 0.85) + (embedding_score * 0.15)
        else:
            similarity = embedding_score

        recommendations.append({
            "job_id": job.id,
            "title": job.title,
            "company": job.company,
            "location": job.location,
            "workplace": job.workplace,
            "employment_type": job.employment_type,
            "education_requirement": getattr(job, "education_requirement", ""),
            "experience_requirement": getattr(job, "experience_requirement", ""),
            "languages": getattr(job, "languages", ""),
            "description": job.description,
            "skills": job.skills,
            "similarity": similarity,
        })

    recommendations.sort(key=lambda x: x["similarity"], reverse=True)

    return recommendations