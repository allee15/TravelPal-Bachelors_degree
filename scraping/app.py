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


def scrape_airbnb(location):
    search_url = f"https://www.airbnb.com/s/{location}/homes"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36"
    }

    response = requests.get(search_url, headers=headers)

    if response.status_code != 200:
        return {"error": "Failed to retrieve data from Airbnb"}

    soup = BeautifulSoup(response.content, 'html.parser')

    listings = soup.find_all('div', {'itemprop': 'itemListElement'}, limit=10)  # Limit to the first 10 listings

    results = []

    for listing in listings:
        title_tag = listing.find('meta', {'itemprop': 'name'})
        image_tag = listing.find('img', {'itemprop': 'image'})

        if title_tag and image_tag:
            title = title_tag['content']
            image_url = image_tag['src']

            results.append({
                "title": title,
                "image": image_url
            })

    return results


@app.route('/properties', methods=['GET'])
def get_properties():
    location = request.args.get("location")
    if not location:
        return jsonify({"error": "No location provided"}), 400

    result = scrape_airbnb(location)

    return jsonify({"properties": result})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)
