from flask import Flask, request, jsonify
from flask_cors import CORS
from ultralytics import YOLO
from PIL import Image
import io
import json

app = Flask(__name__)
CORS(app)  # Allow requests from Flutter or other domains

# Load YOLOv8 model
model = YOLO("best.pt")  # Replace with your actual .pt filename

# Load summaries from JSON file
with open("summaries.json", "r") as f:
    class_summaries = json.load(f)

@app.route("/predict", methods=["POST"])
def predict():
    if 'image' not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    file = request.files['image']
    img = Image.open(file.stream)

    results = model(img)

    predictions = []
    for result in results:
        for box in result.boxes:
            class_id = int(box.cls[0])
            confidence = float(box.conf[0])
            bbox = box.xyxy[0].tolist()  # [x1, y1, x2, y2]

            # Get class summary info from JSON
            class_id_str = str(class_id)
            summary = class_summaries.get(class_id_str, {
                "name": f"Class_{class_id}",
                "description": "No description available."
            })

            predictions.append({
                "class_id": class_id,
                "class_name": summary["name"],
                "description": summary["description"],
                "confidence": confidence,
                "bbox": bbox
            })

    return jsonify(predictions)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
