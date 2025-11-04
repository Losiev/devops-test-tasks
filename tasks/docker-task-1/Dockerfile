FROM python:3.10 AS builder
WORKDIR /app

COPY requirements.txt ./
RUN pip install --upgrade pip && \
pip install --no-cache-dir -r requirements.txt

FROM python:3.10-slim
WORKDIR /app

COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/gunicorn
COPY app.py ./

EXPOSE 8000
ENTRYPOINT [ "gunicorn", "-b", ":8000", "app:app" ]
