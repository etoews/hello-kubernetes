FROM nicolaka/netshoot:latest@sha256:ea3757c995a3b538c45724cd537beeb5363cdc094209920896826082509c26a3

RUN python -m pip install --upgrade pip setuptools wheel

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
