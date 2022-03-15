### STAGE 1: Build ###
FROM node:12-alpine as builder
COPY package.json package-lock.json ./

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
RUN npm ci && mkdir /ng-app && mv ./node_modules ./ng-app


WORKDIR /ng-app
COPY . .

## Build the angular app in production mode and store the artifacts in dist folder

#--base-href=/
RUN npm run ng build -- --prod --output-path=dist --base-href=/


### STAGE 2: Setup ###
FROM nginx:1.15.8-alpine
COPY nginx.conf /etc/nginx/nginx.conf

#02-gifsapp
COPY --from=builder /ng-app/dist /usr/share/nginx/html/02-gifsapp/
CMD ["nginx", "-g", "daemon off;"]