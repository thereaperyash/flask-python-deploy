FROM python:3.10-slim

WORKDIR /cicd

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "flasky.py"]


