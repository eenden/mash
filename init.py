from flask import Flask, render_template, request, send_file
from flask_sqlalchemy import SQLAlchemy
from forms import InputForm
import config
import json
import os
from pprint import pprint

app = Flask(__name__, template_folder = 'templates')
app.config.from_object(config)
db = SQLAlchemy(app)
app.jinja_env.tests['equalto'] = lambda value, other : value == other

def load_sql(name):
	abs_path = os.path.dirname(os.path.abspath(__file__)) + '/sql/' + name
	if os.path.isfile(abs_path):
		with open(abs_path, 'r') as f:
			return f.read()



def get_query_results(filename, params):
	sql = load_sql(filename)
	results = []
	try:
		records = db.session.execute(sql, params)
		for record in records:
			results.append(dict(record.items()))

	except Exception as err:
		print(str(err))
	return results		

@app.route('/', methods = ['GET', 'POST'])
def index():
	
	if request.method == 'GET':
		return render_template('index.html', params = None)

	if request.method == 'POST':
		if request.form['action'] == 'make':
			form = InputForm(request.form)
			if form.validate():
				params = {'minstr': form.data['minstr'], 
					'start_date': form.data['start_date'].strftime('%Y-%m-%d'), 
					'finish_date': form.data['finish_date'].strftime('%Y-%m-%d')
					}
				unique_incidents = get_query_results('query_1.sql', params)
				chart_data = get_query_results('query_2.sql', params)
				incidents_by_persons = get_query_results('query_3.sql', params)
				incidents_by_roads = get_query_results('query_4.sql', params)

				labels =[x['Caption'] for x in chart_data]
				values = [x['ver'] for x in chart_data]
				return render_template('index.html', unique_incidents = unique_incidents,
					labels = labels, values = values, incidents_by_persons = incidents_by_persons,
					incidents_by_roads = incidents_by_roads,
					params = params)
			else:
				errors = form.errors
				return render_template('error.html', errors = errors)


if __name__ == '__main__':
	app.run()
	
