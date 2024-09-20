from bs4 import BeautifulSoup
import requests
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


def scrape_wikipedia(query):
    url = f"https://en.wikipedia.org/wiki/{query}"
    page = requests.get(url)
    soup = BeautifulSoup(page.content, 'html.parser')
    paragraphs = soup.find_all('p')
    paragraph_text = [p.get_text() for p in paragraphs]
    text = " ".join(paragraph_text)
    return text


# print(scrape_wikipedia("Tour_Eiffel"))

@app.route('/information', methods=['GET'])
def generate_info():
    query = request.args.get("query")
    if not query:
        return jsonify({"error": "No query provided"}), 400
    result = scrape_wikipedia(query)
    return jsonify({"query": result})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)
