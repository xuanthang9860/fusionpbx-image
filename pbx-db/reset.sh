docker compose down
rm -rf postgres/*
docker compose up -d
# psql -Ufusionpbx -dfusionpbx -h127.0.0.1