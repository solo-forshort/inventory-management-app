# Inventory Manager

A web-based inventory management system built with Django. Track products and categories, see at a glance what is running low, and manage stock from a clean dashboard. It is deployed on Microsoft Azure with an automated CI/CD pipeline.

## Features

- Login-protected application (Django authentication)
- Dashboard with a summary strip and a "Needs reordering" list that flags low-stock and out-of-stock products
- Create, view, edit and delete for products and categories
- Low-stock rule: a product is flagged when its quantity is at or below its own reorder level
- Responsive sidebar layout with light and dark themes (the choice is saved in the browser)
- Django admin for back-office management

## Tech stack

| Area | Technology |
|---|---|
| Backend | Python 3.13, Django 6.1 |
| Database | PostgreSQL in production, SQLite for local development |
| Frontend | Django templates, Bootstrap 5.3, Bootstrap Icons, custom CSS |
| Web server | Gunicorn, with WhiteNoise serving static files |
| Hosting | Azure App Service (Linux) and Azure Database for PostgreSQL Flexible Server |
| CI/CD | GitHub Actions, using passwordless (OpenID Connect) login to Azure |
| Configuration | python-decouple, dj-database-url |

## Getting started (local)

You need Python 3.10 or newer and Git.

```powershell
git clone https://github.com/solo-forshort/inventory-management-app.git
cd inventory-management-app
python -m venv venv
venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Create a file named `.env` in the project root:

```
SECRET_KEY=replace-with-your-own-long-random-value
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

Then set up the database and start the server:

```powershell
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

Open http://127.0.0.1:8000/ and log in with the account you just created. Without a `DATABASE_URL`, the app uses a local SQLite file.

## Configuration

Settings are read from environment variables (or a local `.env` file). Never commit `.env`.

| Variable | Purpose |
|---|---|
| `SECRET_KEY` | Django's signing key. Use a different value in production. |
| `DEBUG` | `True` for local development. Always `False` in production. |
| `ALLOWED_HOSTS` | Comma-separated host names the app may serve. |
| `CSRF_TRUSTED_ORIGINS` | Comma-separated origins trusted for form submissions (optional). |
| `DATABASE_URL` | Database connection string. Falls back to SQLite when unset. |
| `DB_SSL_REQUIRE` | Set to `True` to require SSL for the database connection. |
| `DEFAULT_REORDER_LEVEL` | Default reorder level (optional). |

If a password in `DATABASE_URL` contains special characters such as `@`, percent-encode them (`@` becomes `%40`).

## Deployment

Pushing to the `main` branch starts a GitHub Actions workflow that builds the app and deploys it to Azure App Service. Production settings come from the App Service environment variables, and the app talks to Azure Database for PostgreSQL over SSL.

When a change adds or alters database models, run `python manage.py migrate` against the production database as well.

## Project structure

```
.
├── inventory/            # The app: models, views, URLs, templates, static files
├── inventory_project/    # Project settings and URL configuration
├── .github/workflows/    # GitHub Actions deployment workflow
├── manage.py
└── requirements.txt
```

## Branching and releases

The project follows a Git Flow style:

- `main` holds production code, and pushing to it deploys the site
- `develop` is where finished work is combined and tested
- `feature/*` branches hold work in progress

Releases are tagged: `v1` (MVP), `v1.1` (deployment fixes) and `v1.2` (new layout and dark mode).

## Roadmap

- Restyle the list, form and login pages to match the dashboard
- Tidy the product form
- Docker container image (in progress)
- Infrastructure as code with Terraform
- Run the app on Kubernetes
- Deploy to a second cloud platform

The database schema also defines suppliers and purchase orders for possible future use. They have no user interface yet.

## Author

Built by Solomon Asare as a hands-on project for learning cloud and DevOps practices.
