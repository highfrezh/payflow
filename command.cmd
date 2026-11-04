mkdir PayFlow
cd PayFlow

dotnet new sln -n PayFlow

dotnet new webapi -n PayFlow.Api -o src/PayFlow.Api

dotnet sln add src/PayFlow.Api/PayFlow.Api.csproj