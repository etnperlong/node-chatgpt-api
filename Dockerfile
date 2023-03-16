FROM node:18 AS build

COPY ./ /app/chatgpt-api

WORKDIR /app/chatgpt-api
RUN npm ci --omit=dev

FROM gcr.io/distroless/nodejs:18 AS dist

COPY --from=build /app/chatgpt-api /app/chatgpt-api
COPY --from=build /app/chatgpt-api/settings.example.js /app/chatgpt-api/settings.js
WORKDIR /app/chatgpt-api

ENV API_HOST=0.0.0.0
ENV API_PORT=3000
ENV REDIS_SERVER_URL='redis://user:pass@redis:6379'
ENV OPENAI_API_KEY=''
ENV BINGAI_HOST='https://www.bing.com'
ENV BINGAI_USER_TOKEN=''
ENV OPENAI_BROWSER_REVERSE_PROXY_URL='https://bypass.duti.tech/api/conversation'
ENV OPENAI_BROWSER_ACCESS_TOKEN=''
ENV OPENAI_BROWSER_COOKIES=''
ENV HTTP_PROXY=''
ENV STORAGE_FILE_PATH='./cache.json'

EXPOSE 3000
CMD ["bin/server.js"]
