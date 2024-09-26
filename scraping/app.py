from bs4 import BeautifulSoup
import requests
from flask import Flask, request, jsonify
from flask_cors import CORS
import json

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
    # Session da store la headers, cookies, etc.
    session = requests.Session()

    url = (f"https://www.airbnb.com.ro/s/{location}/homes?tab_id=home_tab&refinement_paths%5B%5D"
           "=%2Fhomes&flexible_trip_lengths%5B%5D=one_week&monthly_start_date=2024-10-01&monthly_length=3"
           "&monthly_end_date=2025-01-01&price_filter_input_type=0&channel=EXPLORE&query=Bucure%C8%99ti%2C%20Bucharest"
           "&place_id=ChIJT608vzr5sUARKKacfOMyBqw&location_bb=QjIqZ0HRzfpCMVZEQc%2B1qA%3D%3D&date_picker_type=calendar"
           "&source=structured_search_input_header&search_type=autocomplete_click")

    payload = {}
    headers = {
        'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'accept-language': 'ro-RO,ro;q=0.9,en-US;q=0.8,en;q=0.7',
        'cache-control': 'max-age=0',
        'cookie': 'bev=1725136363_EANzg3NWE4NzE4Nz; everest_cookie=1725136363.EAMWM3ZGVhNDk5ZGM0ZG.IDbgH9Yh8CViCjxftyqKusI0tpKhUibVX032ozyJNzI; frmfctr=wide; _cci=cban%3A2765835622; OptanonAlertBoxClosed=2024-08-31T20:38:20.218Z; tzo=180; _ccv=cban%3A0_183215%3D1%2C0_200000%3D1%2C0_183243%3D1%2C0_183216%3D1%2C0_210000%3D1%2C0_210001%3D1%2C0_210002%3D1%2C0_183345%3D1%2C0_179751%3D1%2C0_183219%3D1%2C0_210010%3D1%2C0_200003%3D1%2C0_200005%3D1%2C0_179747%3D1%2C0_183241%3D1%2C0_200007%3D1%2C0_210003%3D1%2C0_210004%3D1%2C0_179754%3D1%2C0_179750%3D1%2C0_179737%3D1%2C0_179744%3D1%2C0_179739%3D1%2C0_179743%3D1%2C0_179749%3D1%2C0_200012%3D1%2C0_200011%3D1%2C0_183217%3D1%2C0_183096%3D1%2C0_179740%3D1%2C0_179752%3D1%2C0_183346%3D1%2C0_183095%3D1; cfrmfctr=DESKTOP; cbkp=4; cdn_exp_0752821c603ff621a=treatment; cdn_exp_6de452700098fbf87=treatment; previousTab=%7B%22id%22%3A%22034b0162-0f97-4340-ace7-52b4a724568f%22%7D; jitney_client_session_id=0d4cd7bb-82a6-419d-ac97-4f2f28b3a832; jitney_client_session_created_at=1727260947.632; ak_bmsc=F5D34A69D481F48E070F2B3FF854764B~000000000000000000000000000000~YAAQlSV+aEcrMhWSAQAAZ3LGKBmTqN2PE8WwUBPq55dIgbOvSgta4p8BiSkmX1484r8IVWQStQwXWb77ue/2UOjrYGv8HsGI8uVi1k9y7NUAGGMrTfLk44J1sOgXu47CgNgExVOiSaOSHOBL02qVsPXEdONteoXYe9Kpbiq4lYklS++j7hayxeRkEhLfDdfug5083W1yqtcGXTNpecAbM08Liy13t5HoSlpYVghfDO5KcUHBtpg4o+1kJO1yuOfSxBIyZt4oX8Uul0rwxSbmlMBYotRHipAH6geHEDwRzupSIOZvV2M1F8WwOhgftBcyKeVi8zF4VuTL76EjrRfO5ImpCN27LYrBDhwr8B6hVtWIm5sEHyg68Zyd7iUkErbgf/h7GvUBMCCv1C0E; _user_attributes=%7B%22device_profiling_session_id%22%3A%221725136363--903c273d35c0d27628589509%22%2C%22giftcard_profiling_session_id%22%3A%221727260956--759ac9756747c0e2213af596%22%2C%22reservation_profiling_session_id%22%3A%221727260956--fd5c0602296616bf2d386fdd%22%2C%22curr%22%3A%22RON%22%7D; OptanonConsent=0_179750%3A1%2C0_183095%3A1%2C0_183241%3A1%2C0_179754%3A1%2C0_183346%3A1%2C0_200000%3A1%2C0_210000%3A1%2C0_210010%3A1%2C0_183215%3A1%2C0_210004%3A1%2C0_179737%3A1%2C0_179752%3A1%2C0_179751%3A1%2C0_179749%3A1%2C0_200007%3A1%2C0_210001%3A1%2C0_200005%3A1%2C0_179740%3A1%2C0_179743%3A1%2C0_179744%3A1%2C0_183243%3A1%2C0_183096%3A1%2C0_179747%3A1%2C0_183216%3A1%2C0_200012%3A1%2C0_183219%3A1%2C0_200003%3A1%2C0_179739%3A1%2C0_210002%3A1%2C0_183217%3A1%2C0_183345%3A1%2C0_210003%3A1%2C0_200011%3A1; jitney_client_session_updated_at=1727261304.853; jitney_client_session_updated_at=1727261399; bm_sv=E7E217F9A44DC2748422D6B95F434468~YAAQliV+aE5YBxSSAQAAjlnNKBmcyu/kaZnvGKGh2jEZTo6GIZIhi86MdAdOnFJmwQ1C0Cc0xM5BljMbVy5DUZWns5AdVAZtP2KgUBNz25+6S8pgnvuqI655FKiLqCCBPjnbd196Htp2xJofsp99Fm3qq9zyy/eNzmsbJRYUWseTJk5G4Z4bj/ZqxnuPcCxyCJgtJ7sGPKblbS2lYTQsG5L3tqXzdlNrqE+1Zv9QET2WOqHnlkloMvTHTKVFaGHOlD98Eg==~1',
        'device-memory': '8',
        'dpr': '1',
        'ect': '4g',
        'priority': 'u=0, i',
        'sec-ch-ua': '"Chromium";v="124", "Google Chrome";v="124", "Not-A.Brand";v="99"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Windows"',
        'sec-ch-ua-platform-version': '"10.0.0"',
        'sec-fetch-dest': 'document',
        'sec-fetch-mode': 'navigate',
        'sec-fetch-site': 'same-origin',
        'sec-fetch-user': '?1',
        'upgrade-insecure-requests': '1',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
        'viewport-width': '1920'
    }

    # pastreaza headerele pt toate request-urile
    session.headers.update(headers)

    # Request-uri prin session pt a parea ca vin de la acelasi user
    response = session.request("GET", url, data=payload)

    html = response.text

    # Ramane parsarea pe html pt a scoate datele din script

    soup = BeautifulSoup(html, 'html.parser')

    content = soup.find(attrs={'id': 'data-deferred-state-0'}).text

    d = json.loads(content)

    found = False
    results = None

    def dfs(node):
        nonlocal found, results
        if isinstance(node, str):
            print
            return
        for _ in node:
            if found:
                return
            elif _ == 'searchResults':
                results = node[_]
                found = True
            else:
                if isinstance(node, dict):
                    dfs(node[_])
                else:
                    dfs(_)

    for _ in d:
        if found:
            break
        elif _ == 'searchResults':
            results = d[_]
            found = True
        else:
            if isinstance(d, str):
                continue
            elif isinstance(d, dict):
                dfs(d[_])
            else:
                dfs(_)

    listings = []
    for i in range(10):
        title = results[i]['listing']['title']
        img = results[i]['contextualPictures'][0]['picture']
        price = results[i]['pricingQuote']['structuredStayDisplayPrice']['primaryLine']['price']
        listings.append({
            'title': title,
            'image': img,
            'price': price
        })
        print(f'{title} - {img} - {price}')
    session.close()
    return listings


#print(scrape_airbnb("Dallas"))


@app.route('/properties', methods=['GET'])
def get_properties():
    location = request.args.get("location")
    if not location:
        return jsonify({"error": "No location provided"}), 400

    result = scrape_airbnb(location)

    return jsonify({"properties": result})


if __name__ == '__main__':
  app.run(debug=True, host='0.0.0.0', port=5001)
