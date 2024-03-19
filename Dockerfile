FROM python:3.9-slim
RUN apt update -y && apt install -y bash
WORKDIR /tmp
COPY . /tmp
RUN pip install --no-cache-dir -r requirements.txt
#RUN pip install Flask
EXPOSE 4444
CMD ["python", "index.py"]

