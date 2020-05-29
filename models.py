from init import db

class UniqIncident(db.Model):
	id = db.Column(db.Integer, primary_key = True)
	name = db.Column(db.String(255), nullable = False)
	count_unique_incidents = db.Column(db.Integer, nullable = False)