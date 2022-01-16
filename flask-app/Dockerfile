FROM python:3.10.1-alpine

COPY ./ /

RUN pip install -r requirements.txt

CMD [ "gunicorn", "app:app" ]