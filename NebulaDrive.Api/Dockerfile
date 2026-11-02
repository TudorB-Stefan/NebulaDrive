FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["NebulaDrive.Api/NebulaDrive.Api.csproj", "NebulaDrive.Api/"]
COPY ["NebulaDrive.Application/NebulaDrive.Application.csproj", "NebulaDrive.Application/"]
COPY ["NebulaDrive.Domain/NebulaDrive.Domain.csproj", "NebulaDrive.Domain/"]
COPY ["NebulaDrive.Infrastructure/NebulaDrive.Infrastructure.csproj", "NebulaDrive.Infrastructure/"]
RUN dotnet restore "NebulaDrive.Api/NebulaDrive.Api.csproj"
COPY . .
WORKDIR "/src/NebulaDrive.Api"
RUN dotnet build "./NebulaDrive.Api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./NebulaDrive.Api.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NebulaDrive.Api.dll"]
