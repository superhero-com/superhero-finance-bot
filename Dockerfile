# Builder
FROM --platform=$BUILDPLATFORM node:20-bullseye as builder

WORKDIR /src

COPY package*.json /src
# for private repos
# eg. docker build . --secret id=GITHUB_TOKEN
RUN --mount=type=secret,id=GITHUB_TOKEN \
    git config --global url."https://x-access-token:$(cat /run/secrets/GITHUB_TOKEN)@github.com/".insteadOf "ssh://git@github.com"
RUN npm ci

RUN npm prune --omit=dev

COPY . /src

CMD ["npm", "start"]