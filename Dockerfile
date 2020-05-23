FROM nicolaka/netshoot

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt

RUN addgroup -S hello && adduser -S hello -G hello
USER hello

COPY --chown=hello:hello . /src
WORKDIR /src

EXPOSE 5000

ENV FLASK_APP=app.py
ENV FLASK_ENV=development
ENV FLASK_RUN_HOST=0.0.0.0

CMD ["flask", "run"]
