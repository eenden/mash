from flask_wtf import FlaskForm
from wtforms import DateField, IntegerField, validators
from datetime import date


class InputForm(FlaskForm):
	minstr = IntegerField(label = 'minstr', validators = [
		validators.DataRequired()
	])

	start_date = DateField(label = 'start_date', validators = [
		validators.DataRequired()
	], default = date.today())


	finish_date = DateField(label = 'finish_date', validators = [
		validators.DataRequired()
	], default = date.today())

	def validate_data(self):
		result = super(InputForm, self).validate()
		if self.start_date.data > self.finish_date.data:
			return False
		else:
			return True
