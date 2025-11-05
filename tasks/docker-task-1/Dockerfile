FROM python:3.10 AS builder
WORKDIR /app

COPY requirements.txt ./
RUN pip install --upgrade pip && \
pip install --no-cache-dir -r requirements.txt

FROM python:3.10-alpine
WORKDIR /app

RUN apk add --no-cache curl

COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/gunicorn
COPY app.py ./

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

EXPOSE 8000
ENTRYPOINT [ "gunicorn", "-b", ":8000", "app:app" ]
