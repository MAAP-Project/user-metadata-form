docker-compose build \
  --build-arg ENV=development \
  --build-arg SECRET_KEY_BASE= \
  --build-arg DATABASE_PASSWORD= \
  --build-arg DATABASE_HOST= \
  --build-arg EARTHDATA_USERNAME= \
  --build-arg EARTHDATA_PASSWORD
