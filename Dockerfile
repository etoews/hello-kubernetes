FROM python:3.8-alpine3.11

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt

COPY . /src
WORKDIR /src

EXPOSE 5000

ENV FLASK_APP=app.py
ENV FLASK_ENV=development

CMD ["flask", "run", "--host=0.0.0.0"]
