FROM golang:1.20-alpine AS build

RUN apk update && apk add upx
WORKDIR /app
COPY main.go go.mod go.sum .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o myurls main.go \
    && upx myurls

FROM scratch
WORKDIR /app
COPY --from=build /app/myurls ./
COPY public/* ./public/

EXPOSE 8002
ENTRYPOINT ["/app/myurls", "-domain", "myurls.3dot141.top", "-port", "8002", "-conn", "apn1-thorough-feline-34121.upstash.io:34121", "-passwd", "d84f3d8e37f04072887089d6d7e9888e"]
