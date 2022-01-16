FROM python:3.10.1-alpine

COPY ./ /

RUN pip install -r requirements.txt

CMD [ "gunicorn", "-b", "0.0.0.0", "app:app" ]