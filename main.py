
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.router import api_router

app = FastAPI(title="SkillIn API")

<<<<<<< Updated upstream
=======
from app.api.v1.router import api_router

# Create DB tables on startup
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Job Recommendation Backend (Sandbox)")

# CORS
>>>>>>> Stashed changes
app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1):\d+",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

<<<<<<< Updated upstream
app.include_router(api_router, prefix="/api/v1")

@app.get("/health")
def health():
    return {"status": "ok"}
=======
# Include API routers
app.include_router(api_router, prefix="/api/v1")

@app.get("/")
def root():
    return {"status": "ok", "message": "Sandbox backend is running"}
>>>>>>> Stashed changes
