from fastapi import FastAPI

app = FastAPI(
    title="Cursor Copilot Trade Account API",
    version="0.1.0",
    description="Backend scaffold for the Unified Trade Account Manager project.",
)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/v1/status")
def status() -> dict[str, str]:
    return {
        "service": "cursor-copilot-backend",
        "phase": "scaffold",
        "message": "Environment is ready for backend development.",
    }
