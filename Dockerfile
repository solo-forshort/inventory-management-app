# 1. Start from an official image that already has Python 3.13 installed
FROM python:3.13-slim

# 2. Python settings that suit containers (no .pyc clutter, logs appear instantly)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3. Work inside the /app folder in the container
WORKDIR /app

# 4. Install the dependencies first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of the project in
COPY . .

# 6. Gather the CSS and other static files for WhiteNoise
RUN python manage.py collectstatic --noinput

# 7. Run as a normal user instead of root
RUN useradd --create-home appuser && chown appuser /app
USER appuser

# 8. The app listens on port 8000
EXPOSE 8000

# 9. Start the production server (gunicorn)
CMD ["gunicorn", "inventory_project.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2", "--access-logfile", "-"]