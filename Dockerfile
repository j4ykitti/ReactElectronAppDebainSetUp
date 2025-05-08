FROM node:18

RUN apt-get update && apt-get install -y \
    libgtk-3-0 libxss1 libnss3 libasound2 libx11-xcb1 libgbm1 xvfb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

CMD ["npm", "run", "dev"]
