FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["Getting Started With Containers/HelloCode.API/HelloCode.API.csproj", "Getting Started With Containers/HelloCode.API/"]
RUN dotnet restore "Getting Started With Containers/HelloCode.API/HelloCode.API.csproj"
COPY . .
WORKDIR "/src/Getting Started With Containers/HelloCode.API"
RUN dotnet build "HelloCode.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloCode.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloCode.API.dll"]
