FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY /DotNetCoreHelloWorld/out .
ENTRYPOINT ["dotnet", "WebApi.dll"]