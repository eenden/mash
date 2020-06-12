from init import db

from flask_security import UserMixin, RoleMixin

class UniqIncident(db.Model):
	id = db.Column(db.Integer, primary_key = True)
	name = db.Column(db.String(255), nullable = False)
	count_unique_incidents = db.Column(db.Integer, nullable = False)

class User(db.Model, UserMixin):
	id = db.Column(db.Integer, primary_key = True)
	login = db.Column(db.String(255))
	password = db.Column(db.String(255))
	
