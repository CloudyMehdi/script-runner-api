# Script Runner API

## Table of Contents

* Introduction
* Prerequisites
* Usage
* Documentation
* CI/CD Pipeline
* Future Improvements
* Conclusion

---

## Introduction

This project is a simple Flask API designed to execute predefined Bash scripts.

The main goal is not the scripts themselves, but to practice building a complete CI/CD pipeline using GitHub Actions and Docker.

The scripts are intentionally simple to keep the focus on infrastructure, automation, and deployment workflows.
The pipeline validates Python tests and ensures the application runs correctly inside a Docker container.

---

## Prerequisites

### Run locally (Python)

To run the API locally, you need to install Python and the required dependencies listed in `requirements.txt`:

* Flask (v3)
* Flask-CORS (v4)
* Gunicorn (v21)

Install them with:

```
pip install -r requirements.txt
```

---

### Run with Docker

To run the project in a container, install Docker:

https://docs.docker.com/engine/install/

---

## Usage

### Run with Python

#### Start the API

From the project root directory:

```
flask --app backend/app run
```

You can optionally enable debug mode:

```
flask --app backend/app run --debug
```

Then open:

```
http://localhost:5000
```

---

#### Run tests

To ensure the project works correctly:

```
python -m unittest discover tests
```

Expected output:

```
Ran 4 tests in 0.500s
OK
```

---

### Run with Docker

Build the image:

```
docker build -t script_runner .
```

Run the container:

```
docker run -dp 5000:5000 --name script-api script_runner
```

Then open:

```
http://localhost:5000
```

Stop the container:

```
docker stop script-api
```

---

## Documentation

Note: Each API route triggers an additional script (`addlogs.sh`) to log executed commands.

### `/api/print`

Returns the provided argument.

---

### `/api/logs`

Returns the last *N* executed commands.
If no value is provided, it defaults to 5.

---

### `/api/ping`

Performs a connectivity check using `curl`.

The standard `ping` command is not usable inside Docker containers due to network restrictions, so it was replaced with an HTTP-based check.

Notes:

* Domain names are resolved correctly inside the container.
* Some edge cases (e.g. direct IP usage) may still cause unexpected behavior.

---

### `/api/health`

Checks the overall status of the application by running multiple internal tests.
Returns the number of successful checks and a global status.

---

### `/api/addlogs`

Logs information about executed commands.

---

## CI/CD Pipeline

This project uses GitHub Actions for automation.

The pipeline is split into two workflows:

* `ci.yml`
  Runs Python tests, builds the Docker image, and verifies that the container starts correctly.

* `deployment.yml`
  Pushes the Docker image to Docker Hub if all previous checks pass.

---

## Future Improvements

* Deploy the application to AWS (EC2 or ECS Fargate)
* Improve the network check to better support IP addresses in containers
* Enhance logging and monitoring

---

## Conclusion

This project was created to demonstrate my interest in DevOps and automation.

Through this project, I learned:

* how to build and structure a CI/CD pipeline
* how to containerize an application with Docker
* how to use Flask in a real-world context

It also highlighted an important insight:

> CI/CD pipelines are not the hardest part — understanding and structuring the project architecture is.

---
