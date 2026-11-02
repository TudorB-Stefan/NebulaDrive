# See https://aka.ms/customizecontainer to learn how to customize your debug container
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy solution and projects for layer caching
COPY ["NebulaDrive.sln", "./"]
COPY ["NebulaDrive.Api/NebulaDrive.Api.csproj", "NebulaDrive.Api/"]
COPY ["NebulaDrive.Application/NebulaDrive.Application.csproj", "NebulaDrive.Application/"]
COPY ["NebulaDrive.Domain/NebulaDrive.Domain.csproj", "NebulaDrive.Domain/"]
COPY ["NebulaDrive.Infrastructure/NebulaDrive.Infrastructure.csproj", "NebulaDrive.Infrastructure/"]

RUN dotnet restore "NebulaDrive.Api/NebulaDrive.Api.csproj"

# Copy the remaining source code and build
COPY . .
WORKDIR "/src/NebulaDrive.Api"
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NebulaDrive.Api.dll"]