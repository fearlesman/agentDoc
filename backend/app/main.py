"""Minimal FastAPI entrypoint for the project base."""

from fastapi import FastAPI

app = FastAPI(title="Document Review Agent", version="0.1.0")


@app.get("/health", tags=["system"])
def health() -> dict[str, str]:
    """Return service health.

    Returns:
        A small health payload for local and internal-network probes.
    """
    return {"status": "ok", "service": "document-review-agent"}
