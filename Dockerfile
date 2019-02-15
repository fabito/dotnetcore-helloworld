# FROM microsoft/dotnet:sdk AS build-env
# WORKDIR /app

# Copy csproj and restore as distinct layers
# COPY Implementation/*.csproj ./
# RUN dotnet restore

# Copy everything else and build
# COPY . ./
# RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY /DotNetCoreHelloWorld/out .
ENTRYPOINT ["dotnet", "WebApi.dll"]