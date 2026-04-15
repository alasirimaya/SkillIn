from fastapi import APIRouter
from auth.router import router as auth_router
from jobs import router as jobs_router
from app.api.v1.recommendation import router as recommendation_router
from .applications import router as applications_router

api_router = APIRouter()

api_router.include_router(auth_router, prefix="/auth")
api_router.include_router(jobs_router)
api_router.include_router(
    recommendation_router,
    prefix="/recommend",
    tags=["Recommendation"],
)
api_router.include_router(applications_router)

@api_router.get("/ping")
def ping():
    return {"message": "pong-HAJAR"}