FROM python:3.8-slim

WORKDIR /api
COPY . /api
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
ENV UPLOAD_FOLDER /api/uploads
RUN mkdir -p ${UPLOAD_FOLDER}

CMD ["python", "api/api.py"]
