from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import subprocess, re, os


BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = Flask(__name__)
CORS(app, resources={
    r"/api/*": {
        "origins": ["http://127.0.0.1:3000"] #For dev purpose
    }
})


@app.route("/")
def index():
    return send_from_directory("../frontend", "index.html")


@app.route("/api/health")
def health_check(): 
    result = subprocess.run(
        ["backend/scripts/health.sh"],
        capture_output=True,
        text=True,
        timeout=15
    )

    parsed = {}
    for line in result.stdout.splitlines():
        if '=' in line:
            key, value = line.split('=', 1)
            parsed[key] = value

    status_raw = parsed.get("status", 500)

    if status_raw == "ok":
        status_value = 200
    elif status_raw == "error":
        status_value = 500
    else:
        try:
            status_value = int(status_raw)
        except:
            status_value = 500

    return jsonify({
        "message": parsed.get("message", "No message"),
        "status": status_value
    })
        


@app.route("/api/ping")
def ping_address():
    destination = request.args.get("destination", "nothing")
    if destination == "nothing":
        return jsonify({
            "message": "Please enter a destination to ping in the input.",
            "status": 400
        })

    if not re.match(r'^[a-zA-Z0-9.\-:\[\]]+$', destination):
        return jsonify({
            "message": "Invalid destination format.",
            "status": 400
        })
    

    else:
        try:
            result = subprocess.run(
                [os.path.join(BASE_DIR, "scripts/ping.sh"), destination],
                capture_output=True,
                text=True,
                timeout=15
            )
            """
                responses:
                0 => Okay
                1 => DNS error
                2 => Timeout
                3 => Unknown error
            """
        
            subprocess.run(
                [os.path.join(BASE_DIR, "scripts/addlogs.sh"), "ping", str(result.returncode), destination],
                timeout=15
            )


            parsed = {}
            for line in result.stdout.splitlines():
                if '=' in line:
                    key, value = line.split('=', 1)
                    parsed[key] = value

            if result.returncode != 0:
                if "message" in parsed.keys():
                    return jsonify({
                        "message": parsed[key],
                        "status": 400
                    })
                else: 
                    return jsonify({
                    "message": result.stdout,
                    "status": 400
                    })

            return jsonify({
                "message": destination + " successfully pinged! — " + parsed["message"],
                "status": 200
            })
        except Exception as e:
            return jsonify({
                "message": str(e),
                "status": 500
            })


@app.route("/api/logs")
def show_logs():
    commands = request.args.get("lines", "5")
    try:
        if not re.match(r'^[0-9]+$', commands):
            return jsonify({
                "message": "The provided value is not a number.",
                "status": 400
            })

        result = subprocess.run(
            [os.path.join(BASE_DIR, "scripts/logs.sh"), commands],
            capture_output=True,
            text=True,
            timeout=15
        )

        subprocess.run(
            [os.path.join(BASE_DIR, "scripts/addlogs.sh"), "logs", str(result.returncode), commands], #add the command and its results in the logfile
            timeout=15
        )

        parsed = {"message": ""}
        for line in result.stdout.splitlines():
            if line.startswith("status=") or line.startswith("message="): 
                key, value = line.split('=', 1)
                parsed[key] = value
            else: 
                parsed["message"] = parsed["message"] + line + "  —  "

        return jsonify({
            "message": "Here are the " + commands + " last queries : " + parsed["message"],
            "status": 200
        })
    
    except Exception as e:
        return jsonify({
            "message": str(e),
            "status": 500
        })


@app.route("/api/print")
def print_terminal():
    arg = request.args.get("arg", "")

    result = subprocess.run (
        [os.path.join(BASE_DIR, "scripts/print.sh"), arg],
        capture_output=True,
        text=True,
        timeout=15
    )
    
    subprocess.run(
        [os.path.join(BASE_DIR, "scripts/addlogs.sh"), "logs", str(result.returncode), arg],
        capture_output=True,
        text=True,
        timeout=15
    )

    parsed = {}
    for line in result.stdout.splitlines():
        if '=' in line:
            key, value = line.split('=', 1)
            parsed[key] = value

    return jsonify({
        "message": parsed["message"],
        "status": 200
    })



@app.errorhandler(404)
def not_found(e):
    return jsonify({
        "message": "function does not exist.",
        "status": 404
    }), 404
