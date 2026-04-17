from fastapi import APIRouter
from auth.router import router as auth_router
from jobs import router as jobs_router

from app.api.v1.recommendation import router as recommendation_router

from .applications import router as applications_router
from app.api.v1.users import router as users_router
api_router = APIRouter()

# Authentication routes
api_router.include_router(auth_router, prefix="/auth")

# Jobs routes
api_router.include_router(jobs_router)

# Recommendation routes
api_router.include_router(recommendation_router, prefix="/recommend", tags=["Recommendation"])


api_router.include_router(jobs_router)  # hajar
api_router.include_router(applications_router)
@api_router.get("/ping")
def ping():
    return {"message": "pong-HAJAR"}
api_router.include_router(users_router)

    