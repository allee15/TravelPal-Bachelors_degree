from bs4 import BeautifulSoup
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/information', methods=['POST'])
def scrape_wikipedia(query):
    url = f"https://en.wikipedia.org/wiki/{query}"
    page = requests.get(url)
    soup = BeautifulSoup(page.content, 'html.parser')
    paragraphs = soup.find_all('p')
    paragraph_text = [p.get_text() for p in paragraphs]
    text = " ".join(paragraph_text)
    return text


# print(scrape_wikipedia("Tour_Eiffel"))

def generate_info():
    data = request.get_json()
    query = data.get('query')
    if not query:
        return jsonify({"error": "No query provided"}), 400
    result = scrape_wikipedia(query)
    return jsonify(result)


if __name__ == '__main__':
    app.run(debug=True)

# run command -> python main.py
