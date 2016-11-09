using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;

public class Program
{
    public static void Main()
    {
        new WebHostBuilder()
            .UseKestrel()
            .Configure(app => app.Run(context => context.Response.WriteAsync("Hello world")))
            .Build()
            .Run();
    }
}