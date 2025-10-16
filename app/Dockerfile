# syntax=docker/dockerfile:1
FROM python:3.12-slim AS build
WORKDIR /opt/app
RUN --mount=type=cache,target=/var/cache/apt apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip pip wheel --wheel-dir=/wheels -r requirements.txt

FROM python:3.12-slim AS runtime
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PORT=8080
WORKDIR /opt/app
RUN addgroup --system app && adduser --system --ingroup app app
COPY --from=build /wheels /wheels
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip pip install --no-index --find-links=/wheels -r requirements.txt && rm -rf /wheels
COPY server.py .
USER app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/')" || exit 1
CMD ["python", "server.py"]
