from flask import Flask
import os


app = Flask(__name__)
app.config.from_object(os.environ.get('SETTINGS'))
app.secret_key = '123456passwordmonkeyletmein'
